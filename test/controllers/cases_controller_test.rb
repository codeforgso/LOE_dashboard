require 'test_helper'

class CasesControllerTest < ActionController::TestCase

  test "should get index" do
    expected_count = Kaminari.config.default_per_page
    create_loe_cases expected_count
    get :index
    assert_response :success
    assert assigns['cases'].kind_of?(LoeCase::ActiveRecord_Relation)
    assert_not_equal 0, assigns['cases'].size
    assert_equal expected_count, assigns['cases'].size
    assert_select "form[action='#{cases_path}'][method=get]" do
      assert_select "table.search" do
        assert_select "input[name='filters[case_number]']"
        assert_select "input[name='filters[entry_date_range][start_date]']"
        assert_select "input[name='filters[entry_date_range][end_date]']"
      end
    end
    assert_select "table tbody" do
      assigns['cases'].each do |item|
        assert_select "tr[data-id='#{item.id}']" do
          assert_select "td a[href='#{case_path(item)}']", text: item.case_number.to_s
        end
      end
    end
  end

  test "should get index filterd for case_number" do
    create_loe_cases
    LoeCase.all.each do |expected|
      get :index, filters: {case_number: expected.case_number}
      assert_equal 1, assigns['cases'].size
      assert_equal expected.case_number, assigns['cases'][0].case_number
    end
  end

  test "should get index filtered for entry_date_range" do
    create_loe_cases Kaminari.config.default_per_page, true
    get :index, filters: {entry_date_range: {start_date: Date.today.to_s, end_date: Date.today.next.to_s}}
    assert_equal Kaminari.config.default_per_page, assigns['cases'].size
    assigns['cases'].each do |loe_case|
      assert [Date.today, Date.today.next].include?(loe_case.entry_date.to_date)
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

  private

  def create_loe_cases(expected_count=Kaminari.config.default_per_page,alternate_date=false)
    expected_count.times do |n|
      opts = {}
      if alternate_date
        opts[:entry_date] = (n%2==0 ? Date.today : Date.today.next).to_time
      end
      create :loe_case, opts
    end
  end

end
