require 'rails_helper'

RSpec.describe "cases/show", type: :view do
  before(:each) do
    @case = assign(:case, create(:loe_case))
  end

  it "renders attributes" do
    render
    assert_select "a[href='#{inspections_path(filters: {'case': @case.id})}']", text: 'Case Inspections'
    assert_select "a[href='#{violations_path(filters: {'case': @case.id})}']", text: 'Case Violations'
    assert_select "a[href='#{case_histories_path(filters: {'case': @case.case_number})}']", text: 'Case Histories'
    assert_select "a[href='#{cases_path}']"
  end
end
