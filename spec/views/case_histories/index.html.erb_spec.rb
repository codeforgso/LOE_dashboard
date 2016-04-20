require 'rails_helper'
require File.expand_path(Rails.root)+'/lib/socrata'

RSpec.describe "case_histories/index", type: :view do
  before(:each) do
    socrata = Socrata.new
    opts = {'$order': 'date, case_number'}
    pending 'API reponds with 400 Bad Request'
    @case_histories = socrata.paginate(socrata.case_history_dataset_id, 1, opts)
  end

  it "renders a list of case_histories" do
    render
    assert_select "table tbody" do
      @case_histories.each do |case_history|
        assert_select "tr[data-unique-id='#{helper.unique_case_history_id(case_history)}']" do
          assert_select "td a[href='#{case_history_path(helper.unique_case_history_id(case_history))}']", text: "#{case_history.case_number} - ##{case_history.case_history_sakey}"
        end
      end
    end
  end

end
