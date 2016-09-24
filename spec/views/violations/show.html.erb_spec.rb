require 'rails_helper'

RSpec.describe "violations/show", type: :view do
  before(:each) do
    @violation = assign(:violation, create(:violation))
  end

  it "renders attributes" do
    render
    assert_select "a[href='#{case_path(@violation.case_number)}']", text: 'View Case'
    assert_select "a[href='#{violations_path}']"
  end
end
