require 'test_helper'

class InspectionTest < ActiveSupport::TestCase

  test "constants" do
    assert_socrata_attribute_remapping Inspection
  end

  test "factories" do
    inspection = build :inspection
    assert_kind_of Inspection, inspection
    assert inspection.valid?
    assert inspection.save
    assert_kind_of LoeCase, inspection.loe_case
    assert_not_nil inspection.loe_case.case_number
    assert_equal inspection.loe_case.case_number, inspection.case_number
  end

  test "for_case scope" do
    assert_respond_to Inspection, :for_case
    loe_case = create :loe_case
    2.times do
      create :inspection
    end
    expected_count = 5
    expected_count.times do
      create :inspection, {loe_case_id: loe_case.id}
    end
    inspections = Inspection.for_case(loe_case.id)
    assert_equal expected_count, inspections.size
    inspections.each do |inspection|
      assert_equal loe_case.id, inspection.loe_case_id
    end
  end

  test "assign_from_socrata" do
    inspection = Inspection.new
    assert_respond_to inspection, :assign_from_socrata
    socrata = Socrata.new
    opts = {
      '$limit' => 1,
      '$offset' => (0..2500).to_a.sample
    }
    item = socrata.client.get(Socrata.inspection_dataset_id, opts).first
    inspection.assign_from_socrata item
    assert_kind_of Fixnum, inspection.case_number
  end
end
