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

  describe 'ActiveRecord associations' do
    it { expect(case_status).to have_many(:loe_cases) }
  end

  describe 'scopes' do
    before do
      create :case_status_open
      create :case_status_closed
    end

    describe 'open' do
      it 'returns record for "Open" case_status' do
        expect(CaseStatus).to respond_to(:open)
        actual = CaseStatus.open
        expect(actual).to be_a(CaseStatus)
        expect(actual.name).to eq('Open')
      end
    end
    describe 'closed' do
      it 'returns record for "Closed" case_status' do
        expect(CaseStatus).to respond_to(:closed)
        actual = CaseStatus.closed
        expect(actual).to be_a(CaseStatus)
        expect(actual.name).to eq('Closed')
      end
    end
  end

end
