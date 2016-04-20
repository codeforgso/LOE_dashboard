require 'rails_helper'
require File.expand_path(::Rails.root)+'/lib/socrata'

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
RSpec.describe CaseHistoriesHelper, type: :helper do

  describe 'unique_case_history_id' do
    let(:socrata) { Socrata.new }
    let(:case_history) { socrata.client.get(socrata.case_history_dataset_id,{'$limit': 1}).first }
    let(:expected) { "#{case_history.case_number}*#{case_history.case_history_sakey}" }
    it 'returns a composite id' do
      expect(helper.unique_case_history_id(case_history)).to eq(expected)
    end
  end

end
