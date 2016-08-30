require 'rails_helper'

RSpec.describe RentalStatus, type: :model do
  let(:rental_status) { build(:rental_status) }
  it 'has factories for testing' do
    expect(rental_status).to be_valid
    expect(rental_status.save!).to eq(true)
  end

  describe 'validations' do
    it { expect(rental_status).to validate_presence_of(:name) }
    it { expect(rental_status).to validate_uniqueness_of(:name) }
  end
end
