require 'test_helper'
require File.expand_path(Rails.root)+'/app/helpers/inspections_helper'
require File.expand_path(Rails.root)+'/lib/socrata'
class InspectionsControllerTest < ActionController::TestCase
  include InspectionsHelper

  test "should get index" do
    [false,true].each do |filter_by_case|
      socrata = Socrata.new
      params = {}
      if filter_by_case
        expected = socrata.client.get(socrata.case_dataset_id, {'$limit': 1}).first
        params[:filters] = {'case': expected.case_number}
      end
      get :index, params
      assert_response :success
      assert assigns['inspections'].kind_of?(Array)
      assert_not_equal 0, assigns['inspections'].size
      assert_select "table tbody" do
        assigns['inspections'].each do |inspection|
          assert_select "tr[data-unique-id='#{unique_inspection_id(inspection)}']" do
            assert_select "td a[href='#{inspection_path(unique_inspection_id(inspection))}']", text: inspection.case_number
            if filter_by_case
              assert_equal expected.case_number, inspection.case_number
            end
          end
        end
      end
    end
  end

  test "should get show" do
    socrata = Socrata.new
    expected = socrata.client.get(socrata.inspection_dataset_id, {'$limit': 1}).first
    get :show, {id: unique_inspection_id(expected)}
    assert_response :success
    assert assigns['inspection'].kind_of?(Hashie::Mash)
    assert_equal expected.case_number, assigns['inspection'].case_number
    assert_select "a[href='#{case_path(assigns['inspection'].case_number)}']", text: 'View Case'
    assert_select "a[href='#{inspections_path}']"
  end

end
