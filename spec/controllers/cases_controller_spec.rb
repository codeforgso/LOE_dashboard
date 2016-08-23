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
      describe 'valid_filters' do
        let(:valid_filters) { controller.send :valid_filters }
        it 'returns an array of valid filter keys' do
          expect(valid_filters).to be_an(Array)
          expect(valid_filters.size).to be > 0
        end
      end
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
      describe 'st_name' do
        let(:st_name) { LoeCase.where('st_name is not ?',nil).sample.st_name }
        it 'returns results filtered by st_name' do
          get :index, filters: { st_name: st_name }
          expect(assigns['cases'].size).to be > 0
          assigns['cases'].each do |loe_case|
            expect(loe_case.st_name).to eq(st_name)
          end
        end
      end
      describe 'full_address' do
        let(:full_address) { LoeCase.where('full_address is not ?',nil).sample.full_address }
        it 'returns results filtered by full_address' do
          get :index, filters: { full_address: full_address }
          expect(assigns['cases'].size).to be > 0
          assigns['cases'].each do |loe_case|
            expect(loe_case.full_address).to eq(full_address)
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

  describe "GET #autocomplete" do
    let(:expected_count) { 8 }
    context 'st_name' do
      before do
        expected_count.times do |n|
          loe_case = build(:loe_case)
          loe_case.st_name = "A#{loe_case.st_name}"
          loe_case.save!
        end
      end
      let(:expected) do
        LoeCase.select('distinct(st_name)').where('st_name ilike ?','A%').limit(expected_count).order(:st_name).map{|c| {"name" => c.st_name} }
      end
      it 'gets a JSON array of Street Names' do
        get :autocomplete, {q: 'A', param: :st_name}, valid_session
        expect(JSON.parse(response.body)).to eq(expected)
        expect(JSON.parse(response.body).size).to eq(expected_count)
      end
    end
    context 'full_address' do
      before do
        expected_count.times do |n|
          loe_case = build(:loe_case)
          loe_case.full_address = "9#{loe_case.full_address}"
          loe_case.save!
        end
      end
      let(:expected) do
        LoeCase.select('distinct(full_address)').where('full_address ilike ?','9%').limit(expected_count).order(:full_address).map{|c| {"name" => c.full_address} }
      end
      it 'gets a JSON array of Street Names' do
        get :autocomplete, {q: '9', param: :full_address}, valid_session
        expect(JSON.parse(response.body)).to eq(expected)
        expect(JSON.parse(response.body).size).to eq(expected_count)
      end
    end
  end

end