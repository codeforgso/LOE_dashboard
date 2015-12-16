require 'test_helper'
class ViolationsHelperTest < ActionView::TestCase
  include ViolationsHelper

  test "unique_violation_id" do
    require File.expand_path(Rails.root)+'/lib/socrata'
    socrata = Socrata.new
    violation = socrata.client.get(socrata.violation_dataset_id,{'$limit': 1}).first
    entry_date = Time.parse violation.entry_date
    expected = "#{violation.case_number}*#{entry_date ? entry_date.to_i : nil}*#{violation.violation_code}"
    assert_equal expected, unique_violation_id(violation)
  end
end