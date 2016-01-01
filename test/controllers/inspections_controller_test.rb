require 'test_helper'
require File.expand_path(Rails.root)+'/app/helpers/inspections_helper'
require File.expand_path(Rails.root)+'/lib/socrata'
class InspectionsControllerTest < ActionController::TestCase
  include InspectionsHelper

  test "should get index" do
    expected_count = Kaminari.config.default_per_page
    [false,true].each do |filter_by_case|
      params = {}
      opts = {}
      if filter_by_case
        expected = create(:loe_case)
        params[:filters] = {'case': expected.id}
        opts[:loe_case_id] = expected.id
      end
      expected_count.times do
        create :inspection, opts
      end
      get :index, params
      assert_response :success
      assert assigns['inspections'].kind_of?(Inspection::ActiveRecord_Relation)
      assert_not_equal 0, assigns['inspections'].size
      assert_equal expected_count, assigns['inspections'].size
      assert_select "table tbody" do
        assigns['inspections'].each do |inspection|
          assert_select "tr[data-id='#{inspection.id}']" do
            assert_select "td a[href='#{inspection_path(inspection.id)}']", text: inspection.case_number.to_s
            if filter_by_case
              assert_equal expected.case_number, inspection.case_number
            end
          end
        end
      end
    end
  end

  test "should get show" do
    expected = create(:inspection)
    get :show, {id: expected.id}
    assert_response :success
    assert assigns['inspection'].kind_of?(Inspection)
    assert_equal expected.case_number, assigns['inspection'].case_number
    assert_select "a[href='#{case_path(assigns['inspection'].loe_case_id)}']", text: 'View Case'
    assert_select "a[href='#{inspections_path}']"
  end

end
