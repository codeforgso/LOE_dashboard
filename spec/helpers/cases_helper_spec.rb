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

  describe 'options_for_use_code' do
    before do
      5.times { create(:use_code) }
    end
    let(:random_use_code) { UseCode.all.sample }
    [false, true].each do |do_select|
      describe "with #{do_select ? 'a' : 'no'} use_code selected" do
        let(:selected) { do_select ? random_use_code.id : nil}
        let(:actual) { helper.options_for_use_code(selected) }
        it 'returns options for select' do
          doc = Nokogiri::HTML.parse(actual)
          if do_select
            expect(doc.css("option[selected][value='#{selected}']").size).to eq(1)
            expect(doc.css("option[selected]").text).to eq(random_use_code.name)
          else
            expect(doc.css('option[selected]').size).to eq(0)
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

end
