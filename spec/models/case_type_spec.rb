require 'rails_helper'

RSpec.describe CaseType, type: :model do
  let(:case_type) { build(:case_type) }
  it 'has factories for testing' do
    expect(case_type).to be_valid
    expect(case_type.save!).to eq(true)
  end

  describe 'validations' do
    it { expect(case_type).to validate_presence_of(:name) }
    it { expect(case_type).to validate_uniqueness_of(:name) }
  end

  describe 'ActiveRecord associations' do
    it { expect(case_type).to have_many(:loe_cases) }
  end
end
