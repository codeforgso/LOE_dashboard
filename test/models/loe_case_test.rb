require 'test_helper'
class LoeCaseTest < ActiveSupport::TestCase

  test "constants" do
    assert_socrata_attribute_remapping LoeCase
  end

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

  test "scopes" do
    total_count = 10
    total_count.times do |n|
      create :loe_case, :entry_date => (n%2==0 ? Date.today : Date.today.next).to_time
    end

    # case_number
    LoeCase.all.each do |expected|
      actual = LoeCase.case_number(expected.case_number)
      assert_equal 1, actual.size
      assert_equal actual[0].case_number, expected.case_number
    end

    # entry_date
    actual = LoeCase.entry_date(Date.today.to_s)
    assert_equal total_count/2, actual.size
    actual.each do |loe_case|
      assert_equal Date.today, loe_case.entry_date.to_date
    end

    # entry_date_range
    actual = LoeCase.entry_date_range(Date.today.to_s,Date.today.next.to_s)
    assert_equal total_count, actual.size
    actual.each do |loe_case|
      assert [Date.today, Date.today.next].include?(loe_case.entry_date.to_date)
    end
  end
end
