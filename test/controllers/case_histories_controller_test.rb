require 'test_helper'
require File.expand_path(Rails.root)+'/app/helpers/inspections_helper'
require File.expand_path(Rails.root)+'/lib/socrata'
class CaseHistoriesControllerTest < ActionController::TestCase
  include CaseHistoriesHelper

  test "should get index" do
    socrata = Socrata.new
    [false,true].each do |filter_by_case|
      params = {}
      if filter_by_case
        case_history = socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first
        expected = socrata.client.get(socrata.case_dataset_id, {'$where': "case_number = '#{case_history.case_number}'"}).first
        params[:filters] = {'case': expected.case_number}
      end
      get :index, params
      assert_response :success
      assert assigns['case_histories'].kind_of?(Array)
      assert_not_equal 0, assigns['case_histories'].size
      assert_select "table tbody" do
        assigns['case_histories'].each do |case_history|
          assert_select "tr[data-unique-id='#{unique_case_history_id(case_history)}']" do
            assert_select "td a[href='#{case_history_path(unique_case_history_id(case_history))}']", text: "#{case_history.case_number} - ##{case_history.case_history_sakey}"
            if filter_by_case
              assert_equal expected.case_number, case_history.case_number
            end
          end
        end
      end
    end
  end

  test "should get show" do
    socrata = Socrata.new
    expected = socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first
    get :show, {id: unique_case_history_id(expected)}
    assert_response :success
    assert assigns['case_history'].kind_of?(Hashie::Mash)
    assert_equal expected.case_number, assigns['case_history'].case_number
    assert_select "a[href='#{case_path(assigns['case_history'].case_number)}']", text: 'View Case'
    assert_select "a[href='#{case_histories_path}']"
  end

end
