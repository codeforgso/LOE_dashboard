require 'test_helper'
class LoeCaseTest < ActiveSupport::TestCase
  test "factories" do
    loe_case = build :loe_case
    assert_kind_of LoeCase, loe_case
    assert loe_case.valid?
    assert loe_case.save
  end

  test "assign_from_socrata" do
    loe_case = LoeCase.new
    assert_respond_to loe_case, :assign_from_socrata
    socrata = Socrata.new
    opts = {
      '$limit' => 1,
      '$offset' => (0..2500).to_a.sample
    }
    item = socrata.client.get(Socrata.case_dataset_id, opts).first
    loe_case.assign_from_socrata item
    assert_kind_of Fixnum, loe_case.case_number
  end
end
