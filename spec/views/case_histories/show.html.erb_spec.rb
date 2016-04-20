require 'rails_helper'
require File.expand_path(Rails.root)+'/lib/socrata'

RSpec.describe "case_histories/show", type: :view do
  before(:each) do
    socrata = Socrata.new
    pending 'API reponds with 400 Bad Request'
    @case_history = socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first
  end

  it "renders attributes" do
    render
    assert_select "a[href='#{case_path(@case_history.case_number)}']", text: 'View Case'
    assert_select "a[href='#{case_histories_path}']"
  end
end
