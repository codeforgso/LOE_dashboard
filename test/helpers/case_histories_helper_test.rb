require 'test_helper'
class CaseHistoriesHelperTest < ActionView::TestCase
  include CaseHistoriesHelper

  test "unique_case_history_id" do
    require File.expand_path(Rails.root)+'/lib/socrata'
    socrata = Socrata.new
    case_history = socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first
    expected = "#{case_history.case_number}*#{case_history.case_history_sakey}"
    assert_equal expected, unique_case_history_id(case_history)
  end
end