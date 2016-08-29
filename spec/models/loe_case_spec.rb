require 'rails_helper'

RSpec.describe LoeCase, type: :model do
  let(:loe_case) { build(:loe_case) }
  it 'has factories for testing' do
    expect(loe_case).to be_valid
    expect(loe_case.save!).to eq(true)
  end

  describe 'constants' do
    it 'has LoeCase::SOCRATA_ATTRIBUTE_REMAPPING' do
      expect(LoeCase).to have_socrata_attribute_remapping
    end
  end

  describe 'ActiveRecord associations' do
    it { expect(loe_case).to have_many(:inspections) }
    it { expect(loe_case).to have_many(:violations) }
    it { expect(loe_case).to belong_to(:case_status) }
    it { expect(loe_case).to belong_to(:use_code) }
  end

  describe 'scopes' do
    before do
      total_count.times do |n|
        opts = {
          entry_date: (n%2==0 ? Date.today : Date.today.next).to_time,
          case_status: n%2==0 ? case_status_open : case_status_closed,
          use_code: n%2==0 ? use_code1 : use_code2
        }
        create :loe_case, opts
      end
    end
    let(:total_count) { 10 }
    let(:case_status_open) { create :case_status_open }
    let(:case_status_closed) { create :case_status_closed }
    let(:use_code1) { create :use_code }
    let(:use_code2) { create :use_code }

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

    [:full_address, :st_name].each do |attribute|
      describe "#{attribute}" do
        let(:subject) { LoeCase.send(attribute, query) }
        let(:query) { LoeCase.where("#{attribute} is not ?",nil).sample.send(attribute) }
        it "returns records with matching #{attribute}" do
          expect(query).to be_a(String)
          expect(query).not_to eq('')
          expect(subject.size).to be > 0
          subject.each do |loe_case|
            expect(loe_case.send(attribute)).to eq(query)
          end
        end

        describe "with lowercased #{attribute}" do
          let(:subject) { LoeCase.send(attribute, query.downcase) }
          it "returns results with case insensitive #{attribute} match" do
            expect(subject.size).to be > 0
            subject.each do |loe_case|
              expect(loe_case.send(attribute)).to eq(query)
              expect(loe_case.send(attribute)).not_to eq(query.downcase)
            end
          end
        end
      end
    end

    describe 'open' do
      let(:actual) { LoeCase.open }
      it 'returns records with Open case status' do
        expect(LoeCase).to respond_to(:open)
        expect(actual.size).to eq(total_count/2)
        actual.each do |loe_case|
          expect(loe_case.case_status_id).to eq(case_status_open.id)
        end
      end
    end

    describe 'closed' do
      let(:actual) { LoeCase.closed }
      it 'returns records with Closed case status' do
        expect(LoeCase).to respond_to(:closed)
        expect(actual.size).to eq(total_count/2)
        actual.each do |loe_case|
          expect(loe_case.case_status_id).to eq(case_status_closed.id)
        end
      end
    end

    describe 'use_code' do
      let(:actual) { LoeCase.use_code(use_code1.id) }
      it 'returns records that match use_code_id' do
        expect(LoeCase).to respond_to(:use_code)
        expect(actual.size).to eq(total_count/2)
        actual.each do |loe_case|
          expect(loe_case.use_code_id).to eq(use_code1.id)
        end
      end
    end

  end

  describe 'google_maps_query' do
    let(:expected) do
      "#{loe_case.full_address}, #{loe_case.city}, #{loe_case.state}"
    end
    it 'returns a query for Google Maps' do
      expect(loe_case.google_maps_query).to eq(expected)
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