require 'rails_helper'

RSpec.describe CaseStatus, type: :model do
  let(:case_status) { build(:case_status) }
  it 'has factories for testing' do
    expect(case_status).to be_valid
    expect(case_status.save!).to eq(true)
  end

  describe 'validations' do
    it { expect(case_status).to validate_presence_of(:name) }
    it { expect(case_status).to validate_uniqueness_of(:name) }
  end
end
