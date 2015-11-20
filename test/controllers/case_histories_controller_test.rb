require 'test_helper'

class CaseHistoriesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert assigns['case_histories'].kind_of?(Array)
    assert_not_equal 0, assigns['case_histories'].size
    assert_select "table tbody" do
      assigns['case_histories'].each do |case_history|
        assert_select "tr[data-case-number='#{case_history.case_number}']" do
          expected_url = "/case_histories/#{case_history.case_number}"
          assert_select "td a[href='#{expected_url}']", text: case_history.case_number
        end
      end
    end
  end

  test "should get show" do
    require File.expand_path(Rails.root)+'/lib/socrata'
    socrata = Socrata.new
    expected = socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first
    get :show, {id: expected.case_number}
    assert_response :success
    assert assigns['case_history'].kind_of?(Hashie::Mash)
    assert_equal expected.case_number, assigns['case_history'].case_number
    assert_select "a[href='#{case_histories_path}']"
  end

end
