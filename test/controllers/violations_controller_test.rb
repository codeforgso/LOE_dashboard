require 'test_helper'

class ViolationsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert assigns['violations'].kind_of?(Array)
    assert_not_equal 0, assigns['violations'].size
    assert_select "table tbody" do
      assigns['violations'].each do |violation|
        assert_select "tr[data-case-number='#{violation.case_number}']" do
          expected_url = "/violations/#{violation.case_number}"
          assert_select "td a[href='#{expected_url}']", text: violation.case_number
        end
      end
    end
  end

  test "should get show" do
    require File.expand_path(Rails.root)+'/lib/socrata'
    socrata = Socrata.new
    expected = socrata.client.get(socrata.violation_dataset_id,{'$limit': 1}).first
    get :show, {id: expected.case_number}
    assert_response :success
    assert assigns['violation'].kind_of?(Hashie::Mash)
    assert_equal expected.case_number, assigns['violation'].case_number
    assert_select "a[href='#{violations_path}']"
  end

end
