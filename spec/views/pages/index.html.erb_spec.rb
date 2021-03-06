require 'rails_helper'

RSpec.describe "pages/index", type: :view do

  it "renders a list of links" do
    render
    assert_select "a[href='#{inspections_path}']", text: 'Browse Inspections', count: 0
    assert_select "a[href='#{violations_path}']", text: 'Browse Violations', count: 0
    assert_select "a[href='#{cases_path}']", text: 'Browse Cases'
    assert_select "a[href='#{case_histories_path}']", text: 'Browse Case Histories', count: 0
  end

end
