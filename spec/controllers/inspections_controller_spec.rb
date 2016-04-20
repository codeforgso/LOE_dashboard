require 'rails_helper'

RSpec.describe InspectionsController, type: :controller do

  let(:valid_session) { {} }

  before(:each) do
    expected_count.times { create :inspection }
  end
  let(:expected_count) { Kaminari.config.default_per_page }

  describe "GET #index" do
    before(:each) do
      expected_count.times { create :inspection }
    end
    let(:expected_count) { Kaminari.config.default_per_page }
    it "responds with 200 OK assigning the expected_count of items" do
      get :index, {}, valid_session
      expect(response.code).to eq("200")
      expect(assigns['inspections'].size).to eq(expected_count)
    end

    describe 'with search filters' do
      describe 'filter_by_case' do
        before do
          params[:filters] = {'case': expected.id}
          expected_count.times do |n|
            if n % 2 == 0
              create :inspection, { loe_case_id: expected.id }
            else
              create :inspection
            end
          end
        end
        let(:expected) { create(:loe_case) }
        let(:params) { {} }
        it 'returns results filtered by case id' do
          get :index, params, valid_session
          expect(assigns(:inspections).size).to eq(expected_count / 2)
          assigns(:inspections).each do |inspection|
            expect(expected.case_number).to eq(inspection.case_number)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:expected) { create(:inspection) }
    it 'assigns @inspection' do
      get :show, { id: expected.id }, valid_session
      expect(assigns[:inspection]).to be_an(Inspection)
      expect(assigns[:inspection]).to eq(expected)
    end
  end

end