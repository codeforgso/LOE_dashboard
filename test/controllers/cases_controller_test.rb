require 'test_helper'

class CasesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert assigns['cases'].kind_of?(Array)
    assert_not_equal 0, assigns['cases'].size
    assert_select "table tbody" do
      assigns['cases'].each do |item|
        assert_select "tr[data-item-number='#{item.case_number}']" do
          assert_select "td a[href='#{case_path(item.case_number)}']", text: item.case_number
        end
      end
    end
  end

  test "should get show" do
    require File.expand_path(Rails.root)+'/lib/socrata'
    socrata = Socrata.new
    expected = socrata.client.get(socrata.case_dataset_id,{'$limit': 1}).first
    get :show, {id: expected.case_number}
    assert_response :success
    assert assigns['case'].kind_of?(Hashie::Mash)
    assert_equal expected.case_number, assigns['case'].case_number
    assert_select "a[href='#{inspections_path(filters: {'case': assigns['case'].case_number})}']", text: 'Case Inspections'
    assert_select "a[href='#{violations_path(filters: {'case': assigns['case'].case_number})}']", text: 'Case Violations'
    assert_select "a[href='#{case_histories_path(filters: {'case': assigns['case'].case_number})}']", text: 'Case Histories'
    assert_select "a[href='#{cases_path}']"
  end

end
