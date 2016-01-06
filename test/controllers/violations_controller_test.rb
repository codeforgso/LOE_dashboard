require 'test_helper'
require File.expand_path(Rails.root)+'/app/helpers/violations_helper'
require File.expand_path(Rails.root)+'/lib/socrata'
class ViolationsControllerTest < ActionController::TestCase
  include ViolationsHelper

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
        create :violation, opts
      end
      get :index, params
      assert_response :success
      assert assigns['violations'].kind_of?(Violation::ActiveRecord_Relation)
      assert_not_equal 0, assigns['violations'].size
      assert_select "table tbody" do
        assigns['violations'].each do |violation|
          assert_select "tr[data-id='#{violation.id}']" do
            assert_select "td a[href='#{violation_path(violation)}']", text: violation.case_number.to_s
            if filter_by_case
              assert_equal expected.case_number, violation.case_number
            end
          end
        end
      end
    end
  end

  test "should get show" do
    expected = create(:violation)
    get :show, {id: expected.id}
    assert_response :success
    assert assigns['violation'].kind_of?(Violation)
    assert_equal expected.case_number, assigns['violation'].case_number
    assert_select "a[href='#{case_path(assigns['violation'].loe_case_id)}']", text: 'View Case'
    assert_select "a[href='#{violations_path}']"
  end

end
