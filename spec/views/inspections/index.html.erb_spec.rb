require 'rails_helper'

RSpec.describe "inspections/index", type: :view do

  before(:each) do
    @inspections = Kaminari.paginate_array(expected_count.times.map do
      create(:inspection)
    end).page(1)
  end
  let(:expected_count) { Kaminari.config.default_per_page }


  it "renders a list of inspections" do
    render
    assert_select "table tbody" do
      @inspections.each do |inspection|
        assert_select "tr[data-id='#{inspection.id}']" do
          assert_select "td a[href='#{inspection_path(inspection.id)}']", text: inspection.case_number.to_s
        end
      end
    end
  end

end
