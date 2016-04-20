require 'rails_helper'
require File.expand_path(Rails.root)+'/lib/socrata'

RSpec.describe CaseHistoriesController, type: :controller do
  include CaseHistoriesHelper

  let(:socrata) { Socrata.new }
  let(:valid_session) { {} }
  let(:expected_count) { Kaminari.config.default_per_page }

  describe "GET #index" do
    it "responds with 200 OK assigning @case_histories" do
      pending 'API reponds with 400 Bad Request'
      get :index, {}, valid_session
      expect(response.code).to eq("200")
      expect(assigns['case_histories'].size).to be > 0
    end

    describe 'with search filters' do
      describe 'filter_by_case' do
        let(:case_history) { socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first }
        let(:expected) { socrata.client.get(socrata.case_dataset_id, {'$where': "case_number = '#{case_history.case_number}'"}).first }
        let(:params) { { filters: { 'case': expected.id } } }
        it 'returns results filtered by case id' do
          pending 'API reponds with 400 Bad Request'
          get :index, params, valid_session
          expect(assigns(:case_histories).size).to be > 0
          assigns(:case_histories).each do |case_history|
            expect(expected.case_number).to eq(case_history.case_number)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:expected) { socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first }
    it 'assigns @case_history' do
      pending 'API reponds with 400 Bad Request'
      get :show, { id: unique_case_history_id(expected) }, valid_session
      expect(assigns[:case_history]).to be_a(Hashie::Mash)
      expect(assigns[:case_history]).to eq(expected)
    end
  end

end