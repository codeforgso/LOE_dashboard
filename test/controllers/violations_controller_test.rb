require 'test_helper'
require File.expand_path(Rails.root)+'/app/helpers/violations_helper'
require File.expand_path(Rails.root)+'/lib/socrata'
class ViolationsControllerTest < ActionController::TestCase
  include ViolationsHelper

  test "should get index" do
    socrata = Socrata.new
    [false,true].each do |filter_by_case|
      params = {}
      if filter_by_case
        violation = socrata.client.get(socrata.violation_dataset_id,{'$limit': 1}).first
        expected = socrata.client.get(socrata.case_dataset_id, {'$where': "case_number = '#{violation.case_number}'"}).first
        params[:filters] = {'case': expected.case_number}
      end
      get :index, params
      assert_response :success
      assert assigns['violations'].kind_of?(Array)
      assert_not_equal 0, assigns['violations'].size
      assert_select "table tbody" do
        assigns['violations'].each do |violation|
          assert_select "tr[data-unique-id='#{unique_violation_id(violation)}']" do
            assert_select "td a[href='#{violation_path(unique_violation_id(violation))}']", text: violation.case_number
            if filter_by_case
              assert_equal expected.case_number, violation.case_number
            end
          end
        end
      end
    end
  end

  test "should get show" do
    socrata = Socrata.new
    expected = socrata.client.get(socrata.violation_dataset_id,{'$limit': 1}).first
    get :show, {id: unique_violation_id(expected)}
    assert_response :success
    assert assigns['violation'].kind_of?(Hashie::Mash)
    assert_equal expected.case_number, assigns['violation'].case_number
    assert_select "a[href='#{case_path(assigns['violation'].case_number)}']", text: 'View Case'
    assert_select "a[href='#{violations_path}']"
  end

end
