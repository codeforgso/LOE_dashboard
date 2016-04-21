require 'rails_helper'

RSpec.describe LoeCase, type: :model do
  let(:loe_case) { build(:loe_case) }
  it 'has factories for testing' do
    expect(loe_case).to be_valid
    expect(!!loe_case.save).to eq(true)
  end

  describe 'constants' do
    it 'has LoeCase::SOCRATA_ATTRIBUTE_REMAPPING' do
      assert_socrata_attribute_remapping LoeCase
    end
  end

  describe 'ActiveRecord associations' do
    it { expect(loe_case).to have_many(:inspections) }
    it { expect(loe_case).to have_many(:violations) }
  end

  describe 'scopes' do
    before do
      total_count.times do |n|
        create :loe_case, :entry_date => (n%2==0 ? Date.today : Date.today.next).to_time
      end
    end
    let(:total_count) { 10 }

    describe 'case_number' do
      it 'returns records for a given case_number' do
        expect(LoeCase).to respond_to(:case_number)
        LoeCase.all.each do |expected|
          actual = LoeCase.case_number(expected.case_number)
          expect(actual.size).to eq(1)
          expect(actual[0].case_number).to eq(expected.case_number)
        end
      end
    end

    describe 'entry_date' do
      let(:actual) { LoeCase.entry_date(Date.today.to_s) }
      it 'returns records for a given entry_date' do
        expect(LoeCase).to respond_to(:entry_date)
        expect(actual.size).to eq(total_count/2)
        actual.each do |loe_case|
          expect(loe_case.entry_date.to_date).to eq(Date.today)
        end
      end
    end

    describe 'entry_date_range' do
      let(:actual) { LoeCase.entry_date_range({start_date: Date.today.to_s, end_date: Date.today.next.to_s}) }
      it 'returns records for a given date range' do
        assert_equal total_count, actual.size
        actual.each do |loe_case|
          expect([Date.today, Date.today.next].include?(loe_case.entry_date.to_date)).to eq(true)
        end
      end
    end

    describe 'st_name' do
      let(:subject) { LoeCase.st_name(st_name) }
      let(:st_name) { LoeCase.where('st_name is not ?',nil).sample.st_name }
      it 'returns records with matching :st_name' do
        expect(st_name).to be_a(String)
        expect(st_name).not_to eq('')
        expect(subject.size).to be > 0
        subject.each do |loe_case|
          expect(loe_case.st_name).to eq(st_name)
        end
      end

      describe 'with lowercased st_name' do
        let(:subject) { LoeCase.st_name(st_name.downcase) }
        it 'returns results with case insensitive st_name match' do
          expect(subject.size).to be > 0
          subject.each do |loe_case|
            expect(loe_case.st_name).to eq(st_name)
            expect(loe_case.st_name).not_to eq(st_name.downcase)
          end
        end
      end
    end
  end

  describe '#assign_from_socrata' do
    let(:loe_case) { LoeCase.new }
    let(:opts) do
      {
        '$limit' => 1,
        '$offset' => (0..2500).to_a.sample
      }
    end
    let(:item) do
      Socrata.new.client.get(Socrata.case_dataset_id, opts).first
    end
    it 'assigns values from a Socrata API response' do
      expect(loe_case).to respond_to(:assign_from_socrata)
      loe_case.assign_from_socrata item
      expect(loe_case.case_number).to be_a(Fixnum)
    end
  end
end