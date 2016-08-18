require 'rails_helper'

RSpec.describe UseCode, type: :model do
  let(:use_code) { build(:use_code) }
  it 'has factories for testing' do
    expect(use_code).to be_valid
    expect(use_code.save!).to eq(true)
  end

  describe 'validations' do
    it { expect(use_code).to validate_presence_of(:name) }
    it { expect(use_code).to validate_uniqueness_of(:name) }
  end

  describe 'ActiveRecord associations' do
    it { expect(use_code).to have_many(:loe_cases) }
  end

  describe '.remap_name' do
    it { expect(UseCode).to respond_to(:remap_name) }
    [
      { name: 'COMME', expected: 'Commercial' },
      { name: 'Commercial', expected: 'Commercial' },
      { name: 'SINGL', expected: 'Single Family' },
      { name: 'SINGLE FAMILY', expected: 'Single Family' }
    ].each do |hash|
      let(:subject) { UseCode.remap_name(hash[:name]) }
      let(:expected) { hash[:expected] }
      it 'remaps duplicate names' do
        expect(subject).to eq(expected)
      end
    end
    10.times do
      let(:name) { Faker::Lorem.word }
      let(:subject) { UseCode.remap_name(name) }
      let(:expected) { name.titleize }
      it 'titleizes names' do
        expect(subject).to eq(expected)
      end
    end
  end
end
