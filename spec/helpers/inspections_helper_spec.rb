require 'rails_helper'

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
RSpec.describe InspectionsHelper, type: :helper do

  describe 'unique_inspection_id' do
    let(:inspection) { build :inspection }
    let(:entry_date) { inspection.entry_date }
    let(:inspection_date) { inspection.inspection_date }
    let(:expected) { "#{inspection.case_number}*#{entry_date ? entry_date.to_i : nil}*#{inspection_date ? inspection_date.to_i : nil}" }
    it 'returns a composite id' do
      expect(helper.unique_inspection_id(inspection)).to eq(expected)
    end
  end

end
