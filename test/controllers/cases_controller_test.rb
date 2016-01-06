require 'test_helper'

class CasesControllerTest < ActionController::TestCase

  test "should get index" do
    expected_count = Kaminari.config.default_per_page
    expected_count.times do
      create :loe_case
    end
    get :index
    assert_response :success
    assert assigns['cases'].kind_of?(LoeCase::ActiveRecord_Relation)
    assert_not_equal 0, assigns['cases'].size
    assert_equal expected_count, assigns['cases'].size
    assert_select "table tbody" do
      assigns['cases'].each do |item|
        assert_select "tr[data-id='#{item.id}']" do
          assert_select "td a[href='#{case_path(item)}']", text: item.case_number.to_s
        end
      end
    end
  end

  test "should get show" do
    expected = create :loe_case
    get :show, {id: expected.id}
    assert_response :success
    assert assigns['case'].kind_of?(LoeCase)
    assert_equal expected.case_number, assigns['case'].case_number
    assert_select "a[href='#{inspections_path(filters: {'case': assigns['case'].id})}']", text: 'Case Inspections'
    assert_select "a[href='#{violations_path(filters: {'case': assigns['case'].id})}']", text: 'Case Violations'
    assert_select "a[href='#{case_histories_path(filters: {'case': assigns['case'].case_number})}']", text: 'Case Histories'
    assert_select "a[href='#{cases_path}']"
  end

end
