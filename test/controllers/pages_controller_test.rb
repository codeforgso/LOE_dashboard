require 'test_helper'
class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select "header.main > a[href='/']", text: 'Home'
    assert_select "a[href='#{inspections_path}']", text: 'Browse Inspections'
  end

end
