require 'test_helper'
class InspectionsHelperTest < ActionView::TestCase
  include InspectionsHelper

  test "unique_inspection_id" do
    require File.expand_path(Rails.root)+'/lib/socrata'
    socrata = Socrata.new
    inspection = socrata.client.get(socrata.inspection_dataset_id,{'$limit': 1}).first
    entry_date = Time.parse inspection.entry_date
    inspection_date = Time.parse inspection.inspection_date
    expected = "#{inspection.case_number}*#{entry_date ? entry_date.to_i : nil}*#{inspection_date ? inspection_date.to_i : nil}"
    assert_equal expected, unique_inspection_id(inspection)
  end
end