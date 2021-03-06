require 'rails_helper'
require 'nokogiri'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CasesHelper, type: :helper do

  [UseCode, RentalStatus, CaseType].each do |klass|
    describe "options_for_#{klass.model_name.param_key}" do
      before do
        klass.delete_all
        expected_count.times { create(param) }
      end
      let(:param) { klass.model_name.param_key.to_sym }
      let(:method) { "options_for_#{param}".to_sym }
      let(:expected_count) { 5 }
      let(:random_option) { klass.all.sample }
      [false, true].each do |do_select|
        describe "with #{do_select ? 'a' : 'no'} #{klass.model_name.param_key} selected" do
          let(:selected) { do_select ? random_option.id : nil}
          let(:actual) { helper.send(method, selected) }
          it 'returns options for select' do
            expect(klass.all.size).to eq(expected_count)
            expect(random_option).to be_a(klass)
            doc = Nokogiri::HTML.parse(actual)
            if do_select
              expect(doc.css("option[selected][value='#{selected}']").size).to eq(1)
              expect(doc.css("option[selected]").text).to eq(random_option.name)
            else
              expect(doc.css('option[selected]').size).to eq(0)
            end
          end
        end
      end
    end
  end

  describe '#sort_dir' do
    let(:param) { Faker::Lorem.word.downcase.to_sym }
    [nil, true, false].each do |param_selected|
      context "with#{param_selected.nil? ? ' no' : (param_selected ? nil : 'out')} param#{param_selected.nil? ? 's' : nil} selected" do
        [false, true].each do |descending|
          context "with #{descending ? 'descending' : 'ascending'} sort order" do
            let(:params) do
              {
                sort: param_selected.nil? ? nil : (param_selected ? param : 'foo'),
                sort_dir: param_selected.nil? ? nil : (descending ? 'DESC' : 'ASC')
              }
            end
            let(:actual) { helper.sort_dir(param) }
            let(:expected) do
              if param_selected
                params[:sort_dir] == 'DESC' ? 'ASC' : 'DESC'
              else
                'DESC'
              end
            end
            it 'returns the appropriate sort direction' do
              allow(helper).to receive(:params).and_return(params)
              expect(actual).to eq(expected)
            end
          end
        end
      end
    end
  end

  describe 'case_items' do
    let(:expected) do
      [:case_number, :case_type, :origin, :entry_date].map do |attribute|
        value = case attribute
        when :case_type
          loe_case.send(attribute).try(:name)
        else
          loe_case.send(attribute)
        end
        {
          label: attribute.to_s.titleize,
          value: value
        }
      end
    end
    let(:actual) { helper.case_items(loe_case) }
    let(:loe_case) { create(:loe_case) }
    it 'returns an array of items for #show template' do
      expect(actual).to eq(expected)
    end
  end

  describe 'case_address_items' do
    let(:loe_case) { create(:loe_case) }
    [false, true].each do |owner_info|
      let(:expected) do
        if opts[:owner]
          items = [:owner_name2, :owner_mailaddr, :owner_mailaddr2]
          address_city = loe_case.owner_mailcity
          address_state = loe_case.owner_mailstate
          address_zip = loe_case.owner_mailzip
        else
          items = [:full_address]
          address_city = loe_case.city
          address_state = loe_case.state
          address_zip = '' #loe_case.zip
        end
        items.map do |item|
          loe_case[item] unless loe_case[item].blank?
        end.compact + [
          "#{address_city}, #{address_state} #{address_zip}"
        ]
      end
      let(:actual) { helper.case_address_items(loe_case, opts) }
      let(:opts) do
        if owner_info
          {owner: true}
        else
          {}
        end
      end
      it 'returns an array of items for #show template' do
        expect(actual).to eq(expected)
      end
    end
  end

  describe 'search_fields' do
    let(:actual) { helper.search_fields }
    let(:expected_keys) { [:title, :attr, :html_opts, :value, :html, :param_name] }
    let(:params) { { filters: { entry_date_range: {} } } }
    it 'returns an array of options for search field markup' do
      allow(helper).to receive(:params).and_return(params)
      expect(actual).to be_an(Array)
      expect(actual.size).to be > 0
      actual.each do |item|
        expect(item).to be_a(Hash)
        expect((item.keys & expected_keys).sort).to eq(expected_keys.sort)
      end
    end
  end

  [:date_field_opts, :autocomplete_field_opts, :search_date_fields, :search_date_field_value].each do |method|

    describe "#{method}" do
      it 'is a private method' do
        expect(helper.private_methods.include?(method)).to eq(true)
      end
    end
  end

end
