require 'test_helper'
class ViolationsHelperTest < ActionView::TestCase
  include ViolationsHelper

  test "unique_violation_id" do
    violation = build :violation
    entry_date = violation.entry_date
    expected = "#{violation.case_number}*#{entry_date ? entry_date.to_i : nil}*#{violation.violation_code}"
    assert_equal expected, unique_violation_id(violation)
  end
end