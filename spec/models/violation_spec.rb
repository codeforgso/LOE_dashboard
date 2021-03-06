require 'rails_helper'

RSpec.describe Violation, type: :model do
  let(:violation) { build(:violation) }
  it 'has factories for testing' do
    expect(violation).to be_valid
    expect(violation.save!).to eq(true)
    expect(violation.loe_case).to be_a(LoeCase)
    expect(violation.loe_case.case_number).to eq(violation.case_number)
  end

  describe 'constants' do
    it 'has Violation::SOCRATA_ATTRIBUTE_REMAPPING' do
      expect(Violation).to have_socrata_attribute_remapping
    end
  end

  describe 'ActiveRecord associations' do
    it { expect(violation).to belong_to(:loe_case) }
  end

  describe 'scopes' do
    describe 'for_case' do
      before do
        2.times do
          create :violation
        end
        expected_count.times do
          create :violation, {loe_case_id: loe_case.id}
        end
      end
      let(:expected_count) { 5 }
      let(:loe_case) { create :loe_case }
      let(:subject) { Violation.for_case(loe_case.id) }
      it 'returns records for a given loe_case_id' do
        expect(Violation).to respond_to(:for_case)
        expect(subject.size).to eq(expected_count)
        subject.each do |violation|
          expect(violation.loe_case_id).to eq(loe_case.id)
        end
      end
    end
  end

  describe '#assign_from_socrata' do
    let(:violation) { Violation.new }
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
      expect(violation).to respond_to(:assign_from_socrata)
      violation.assign_from_socrata item
      expect(violation.case_number).to be_a(Fixnum)
    end
  end
end