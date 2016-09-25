require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  let(:valid_session) { {} }

  describe "GET #js_config" do
    let(:expected) do
      {
        google_maps_api_key: ENV['GOOGLE_MAPS_API_KEY']
      }.to_json
    end
    it "responds with 200 OK" do
      get :js_config, {}, valid_session
      expect(response.code).to eq("200")
      expect(response.body).to eq(expected)
    end
  end

end