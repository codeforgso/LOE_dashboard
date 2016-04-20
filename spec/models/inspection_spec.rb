require 'rails_helper'

RSpec.describe Inspection, type: :model do
  let(:inspection) { build(:inspection) }
  it 'has factories for testing' do
    expect(inspection).to be_valid
    expect(!!inspection.save).to eq(true)
    expect(inspection.loe_case).to be_a(LoeCase)
    expect(inspection.case_number).to eq(inspection.loe_case.case_number)
  end

  describe 'constants' do
    it 'has Inspection::SOCRATA_ATTRIBUTE_REMAPPING' do
      assert_socrata_attribute_remapping Inspection
    end
  end

  describe 'ActiveRecord associations' do
    it { expect(inspection).to belong_to(:loe_case) }
  end

  describe 'scopes' do
    describe 'for_case' do
      before do
        2.times do
          create :inspection
        end
        expected_count.times do
          create :inspection, {loe_case_id: loe_case.id}
        end
      end
      let(:expected_count) { 5 }
      let(:loe_case) { create :loe_case }
      let(:subject) { Inspection.for_case(loe_case.id) }
      it 'returns records for a given loe_case_id' do
        expect(Inspection).to respond_to(:for_case)
        expect(subject.size).to eq(expected_count)
        subject.each do |inspection|
          expect(inspection.loe_case_id).to eq(loe_case.id)
        end
      end
    end
  end

  describe '#assign_from_socrata' do
    let(:inspection) { Inspection.new }
    let(:opts) do
      {
        '$limit' => 1,
        '$offset' => (0..2500).to_a.sample
      }
    end
    let(:item) do
      Socrata.new.client.get(Socrata.inspection_dataset_id, opts).first
    end
    it 'assigns values from a Socrata API response' do
      expect(inspection).to respond_to(:assign_from_socrata)
      inspection.assign_from_socrata item
      expect(inspection.case_number).to be_a(Fixnum)
    end
  end
end
