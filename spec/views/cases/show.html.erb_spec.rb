require 'rails_helper'

RSpec.describe "cases/show", type: :view do
  before(:each) do
    @case = assign(:case, create(:loe_case))
  end

  let(:items) { [:summary, :inspections, :violations, :details] }
  [false, true].each do |build_associations|
    context "with#{build_associations ? nil : 'out'} associations" do
      before do
        if build_associations
          expected_count.times do
            create(:violation, loe_case_id: @case.id)
            create(:inspection, loe_case_id: @case.id)
          end
        end
      end
      let(:expected_count) { build_associations ? 5 : 0 }
      it "renders attributes" do
        render
        assert_select 'h1', text: /^Case Detail/
        assert_select 'h1 > small', text: "Case ##{@case.case_number}"
        assert_select 'div' do
          assert_select 'ul.nav-tabs' do
            items.each do |item|
              assert_select "li > a[href='##{item}']", text: item.to_s.titleize
            end
          end
          assert_select 'div.tab-content' do
            items.each do |item|
              assert_select "div[id='#{item}'].tab-pane" do
                case item
                when :summary
                  assert_select 'div.row' do
                    assert_select 'dt', text: 'Case Number'
                    assert_select 'dd', text: @case.case_number.to_s
                    assert_select 'h3', text: 'Case Notes'
                    assert_select 'pre', text: @case.case_notes
                    assert_select 'h3', text: 'Owner Information'
                    assert_select 'address', text: /#{Regexp.escape(@case.owner_name)}/
                  end
                when :inspections
                  expect(@case.inspections.size).to eq(expected_count)
                  assert_select 'div', text: 'There are no inspections for this case.', count: (expected_count == 0 ? 1 : 0)
                  assert_select 'ul', count: (expected_count == 0 ? 0 : 1) do
                    assert_select 'li', count: expected_count
                  end
                when :violations
                  expect(@case.violations.size).to eq(expected_count)
                  assert_select 'div', text: 'There are no violations for this case.', count: (expected_count == 0 ? 1 : 0)
                  assert_select 'ul', count: (expected_count == 0 ? 0 : 1) do
                    assert_select 'li', count: expected_count
                  end
                when :details
                  assert_select 'pre', text: @case.attributes.to_yaml
                end
              end
            end
          end
        end
        assert_select "a[href='#{inspections_path(filters: {'case': @case.id})}']", text: 'Case Inspections', count: 0
        assert_select "a[href='#{violations_path(filters: {'case': @case.id})}']", text: 'Case Violations', count: 0
        assert_select "a[href='#{case_histories_path(filters: {'case': @case.case_number})}']", text: 'Case Histories', count: 0
        assert_select "a[href='#{cases_path}']"
      end
    end
  end
end
