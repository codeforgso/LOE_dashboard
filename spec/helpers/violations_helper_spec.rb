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
RSpec.describe ViolationsHelper, type: :helper do

  describe 'unique_violation_id' do
    let(:violation) { build :violation }
    let(:entry_date) { violation.entry_date }
    let(:expected) { "#{violation.case_number}*#{entry_date ? entry_date.to_i : nil}*#{violation.violation_code}" }
    it 'returns a composite id' do
      expect(helper.unique_violation_id(violation)).to eq(expected)
    end
  end

end
