require 'test_helper'

class ViolationTest < ActiveSupport::TestCase

  test "factories" do
    violation = build :violation
    assert_kind_of Violation, violation
    assert violation.valid?
    assert violation.save
    assert_kind_of LoeCase, violation.loe_case
    assert_not_nil violation.loe_case.case_number
    assert_equal violation.loe_case.case_number, violation.case_number
  end

  test "for_case scope" do
    assert_respond_to Inspection, :for_case
    loe_case = create :loe_case
    2.times do
      create :violation
    end
    expected_count = 5
    expected_count.times do
      create :violation, {loe_case_id: loe_case.id}
    end
    violations = Violation.for_case(loe_case.id)
    assert_equal expected_count, violations.size
    violations.each do |violation|
      assert_equal loe_case.id, violation.loe_case_id
    end
  end

  test "assign_from_socrata" do
    violation = Violation.new
    assert_respond_to violation, :assign_from_socrata
    socrata = Socrata.new
    opts = {
      '$limit' => 1,
      '$offset' => (0..2500).to_a.sample
    }
    item = socrata.client.get(Socrata.violation_dataset_id, opts).first
    violation.assign_from_socrata item
    assert_kind_of Fixnum, violation.case_number
  end
end
