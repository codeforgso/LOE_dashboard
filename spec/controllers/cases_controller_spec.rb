require 'rails_helper'

RSpec.describe CasesController, type: :controller do

  let(:valid_session) { {} }

  before(:each) do
    expected_count.times { create :loe_case }
  end
  let(:expected_count) { Kaminari.config.default_per_page }

  describe "GET #index" do
    it "responds with 200 OK" do
      get :index, {}, valid_session
      expect(response.code).to eq("200")
      expect(assigns['cases']).to be_a(LoeCase::ActiveRecord_Relation)
      expect(assigns['cases'].size).to be > 0
      expect(assigns['cases'].size).to eq(expected_count)
    end

    describe 'with search filters' do
      describe 'case_number' do
        it 'returns results for a given case_number' do
          LoeCase.all.each do |expected|
            get :index, filters: {case_number: expected.case_number}
            expect(assigns['cases'].size).to eq(1)
            expect(assigns['cases'][0].case_number).to eq(expected.case_number)
          end
        end
      end
      describe 'entry_date_range' do
        it 'returns results filterd by entry_date' do
          LoeCase.all.each_with_index do |loe_case, idx|
            loe_case.entry_date = (idx % 2 == 0 ? Date.today : Date.today.next).to_time
            loe_case.save
          end
          get :index, filters: {entry_date_range: {start_date: Date.today.to_s, end_date: Date.today.next.to_s}}
          assert_equal expected_count, assigns['cases'].size
          assigns['cases'].each do |loe_case|
            assert [Date.today, Date.today.next].include?(loe_case.entry_date.to_date)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:expected) { create :loe_case }
    it 'assigns @loe_case' do
      get :show, {id: expected.id}
      expect(response.code).to eq("200")
      expect(assigns['case']).to be_a(LoeCase)
      expect(assigns['case'].case_number).to eq(expected.case_number)
    end
  end

end