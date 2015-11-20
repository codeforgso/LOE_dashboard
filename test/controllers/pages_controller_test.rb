require 'test_helper'
class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select "header.main > a[href='/']", text: 'Home'
    assert_select "a[href='#{inspections_path}']", text: 'Browse Inspections'
    assert_select "a[href='#{violations_path}']", text: 'Browse Violations'
    assert_select "a[href='#{cases_path}']", text: 'Browse Cases'
    assert_select "a[href='#{case_histories_path}']", text: 'Browse Case Histories'
  end

end
