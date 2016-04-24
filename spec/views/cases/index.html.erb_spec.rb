require 'rails_helper'

RSpec.describe "cases/index", type: :view do

  before(:each) do
    @cases = Kaminari.paginate_array(expected_count.times.map do
      create(:loe_case)
    end).page(1)
  end
  let(:expected_count) { Kaminari.config.default_per_page }
  let(:params) { { filters: {} } }

  it "renders a list of cases" do
    allow(view).to receive(:params).and_return(params)
    render
    assert_select "form[action='#{cases_path}'][method=get]" do
      assert_select "input[name='filters[case_number]']"
      assert_select "input[name='filters[entry_date_range][start_date]']"
      assert_select "input[name='filters[entry_date_range][end_date]']"
      assert_select "input[name='filters[st_name]']"
    end
    assert_select 'h2', text: /^Listing Cases/ do
      assert_select 'small', text: "(#{pluralize(@cases.total_count, 'total record')})"
    end
    assert_select "table tbody" do
      @cases.each do |item|
        assert_select "tr[data-id='#{item.id}']" do
          assert_select "td a[href='#{case_path(item)}']", text: item.case_number.to_s
        end
      end
    end
  end

end
