require 'test_helper'
class InspectionsHelperTest < ActionView::TestCase
  include InspectionsHelper

  test "unique_inspection_id" do
    inspection = build :inspection
    entry_date = inspection.entry_date
    inspection_date = inspection.inspection_date
    expected = "#{inspection.case_number}*#{entry_date ? entry_date.to_i : nil}*#{inspection_date ? inspection_date.to_i : nil}"
    assert_equal expected, unique_inspection_id(inspection)
  end
end