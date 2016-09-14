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
          valid_filters.each do |key|
            expect(LoeCase).to respond_to(key)
          end
          [:use_code, :rental_status, :case_type].each do |attribute|
            expect(valid_filters.include?(attribute)).to eq(true)
          end
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
      [:st_name, :full_address, :owner_name].each do |attribute|
        describe "#{attribute}" do
          let(:subject) { LoeCase.where("#{attribute} is not ?",nil).sample.send(attribute) }
          let(:new_select_for_index) do
            controller.send(:select_for_index) + [attribute]
          end
          it "returns results filtered by #{attribute}" do
            allow_any_instance_of(CasesController).to receive(:select_for_index).and_return(new_select_for_index)
            params = { filters: {} }
            params[:filters][attribute] =  subject
            get :index, params
            expect(assigns['cases'].size).to be > 0
            assigns['cases'].each do |loe_case|
              expect(loe_case.send(attribute)).to eq(subject)
            end
          end
        end
      end
    end
    context 'with sort parameters' do
      [nil, :entry_date, :case_number].each do |sort_param|
        context "with #{sort_param.nil? ? 'nil' : sort_param} as :sort" do
          ['DESC', 'ASC'].each do |sort_dir|
            sort_dir = nil if sort_param.nil?
            context "with #{sort_dir.nil? ? 'nil' : sort_dir} as :sort_dir" do
              let(:params) do
                {
                  sort: sort_param,
                  sort_dir: sort_dir
                }
              end
              it 'returns records sorted appropriately' do
                get :index, params, valid_session
                expect(assigns(:cases).size).to eq(expected_count)
                case sort_param
                when nil
                  sorted = assigns(:cases).sort {|x, y| x.entry_date <=> y.entry_date }
                when :entry_date, :case_number
                  if sort_dir == 'ASC'
                    sorted = assigns(:cases).sort {|x, y| x[sort_param] <=> y[sort_param] }
                  else
                    sorted = assigns(:cases).sort {|x, y| y[sort_param] <=> x[sort_param] }
                  end
                else
                  pending "TODO: add #{sort_parm} to #{File.basename(__FILE__)}:#{__LINE__}"
                end
                expect(assigns(:cases)).to eq(sorted)
              end
            end
          end
        end
      end
    end
  end
  describe 'GET #show' do
    let(:expected) { create :loe_case }
    it 'assigns @loe_case' do
      get :show, {case_number: expected.case_number}
      expect(response.code).to eq("200")
      expect(assigns['case']).to be_a(LoeCase)
      expect(assigns['case'].case_number).to eq(expected.case_number)
      expect(assigns['case'].association_cache.keys.include?(:violations)).to eq(true)
      expect(assigns['case'].association_cache.keys.include?(:inspections)).to eq(true)
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

  describe 'valid_sorts' do
    let(:expected) { [:entry_date, :case_number] }
    let(:actual) { controller.send(:valid_sorts) }
    it 'returns an array of valid attributes for sorting' do
      expect(actual).to eq(expected)
    end
  end

  describe 'select_for_index' do
    let(:expected) { [:id, :case_number, :case_notes, :entry_date] }
    let(:actual) { controller.send(:select_for_index) }
    it do
      expect(actual).to eq(expected)
    end
  end
end