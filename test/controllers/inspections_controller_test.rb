require 'test_helper'
class InspectionsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert assigns['inspections'].kind_of?(Array)
    assert_not_equal 0, assigns['inspections'].size
    assert_select "table tbody" do
      assigns['inspections'].each do |inspection|
        assert_select "tr[data-case-number='#{inspection.case_number}']" do
          expected_url = "/inspections/#{inspection.case_number}"
          assert_select "td a[href='#{expected_url}']", text: inspection.case_number
        end
      end
    end
  end

  test "should get show" do
    require File.expand_path(Rails.root)+'/lib/socrata'
    socrata = Socrata.new
    expected = socrata.client.get(socrata.inspection_dataset_id,{'$limit': 1}).first
    get :show, {id: expected.case_number}
    assert_response :success
    assert assigns['inspection'].kind_of?(Hashie::Mash)
    assert_equal expected.case_number, assigns['inspection'].case_number
    assert_select "a[href='#{inspections_path}']"
  end

end
