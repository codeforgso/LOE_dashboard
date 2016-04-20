require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  let(:valid_session) { {} }

  describe "GET #index" do
    it "responds with 200 OK" do
      get :index, {}, valid_session
      expect(response.code).to eq("200")
    end
  end

end