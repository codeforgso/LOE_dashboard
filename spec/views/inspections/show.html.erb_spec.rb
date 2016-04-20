require 'rails_helper'

RSpec.describe "inspections/show", type: :view do
  before(:each) do
    @inspection = assign(:inspection, create(:inspection))
  end

  it "renders attributes" do
    render
    assert_select "a[href='#{case_path(@inspection.loe_case_id)}']", text: 'View Case'
    assert_select "a[href='#{inspections_path}']"
  end
end
