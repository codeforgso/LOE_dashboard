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
end
