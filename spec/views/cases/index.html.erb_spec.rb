require 'rails_helper'

RSpec.describe "cases/index", type: :view do

  before(:each) do
    @cases = Kaminari.paginate_array(expected_count.times.map do
      create(:loe_case)
    end).page(1)
  end
  let(:expected_count) { Kaminari.config.default_per_page }
  let(:params) do
    hash = {
      filters: {
        entry_date_range: {
          start_date: Faker::Time.between(Date.today, Time.now.advance(years: -5), :day)
        }
      }
    }
    hash[:filters][:entry_date_range][:end_date] = Faker::Time.between(Date.today, hash[:filters][:entry_date_range][:start_date], :day)
    hash
  end

  it "renders a list of cases" do
    allow(view).to receive(:params).and_return(params)
    render
    expect(response).to render_template(partial: '_filters')
    assert_select "form[action='#{cases_path}'][method=get]" do
      assert_select "input[name='filters[case_number]']"
      assert_select "input[name='filters[entry_date_range][start_date]'][value='#{params[:filters][:entry_date_range][:start_date].strftime('%Y-%m-%d')}']"
      assert_select "input[name='filters[entry_date_range][end_date]'][value='#{params[:filters][:entry_date_range][:end_date].strftime('%Y-%m-%d')}']"
      assert_select "input[name='filters[st_name]'][data-autocomplete='true']"
      assert_select "select[name='filters[use_code]']"
    end
    assert_select 'h2', text: /^Listing Cases/ do
      assert_select 'small', text: "(#{pluralize(@cases.total_count, 'total record')})"
    end
    assert_select 'table' do
      assert_select 'thead' do
        assert_select "th a[href='#{cases_path(sort: :case_number, sort_dir: 'DESC', filters: params[:filters])}']" , text: 'Case Number'
        assert_select "th a[href='#{cases_path(sort: :entry_date, sort_dir: 'DESC', filters: params[:filters])}']" , text: 'Entry Date'
      end
      assert_select 'tbody' do
        @cases.each do |item|
          assert_select "tr[data-id='#{item.id}']" do
            assert_select "td a[href='#{case_path(item)}']", text: item.case_number.to_s
          end
        end
      end
    end
  end

end
