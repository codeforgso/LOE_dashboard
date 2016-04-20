require 'rails_helper'

RSpec.describe "violations/index", type: :view do

  before(:each) do
    @violations = Kaminari.paginate_array(expected_count.times.map do
      create(:violation)
    end).page(1)
  end
  let(:expected_count) { Kaminari.config.default_per_page }


  it "renders a list of violations" do
    render
    assert_select "table tbody" do
      @violations.each do |violation|
        assert_select "tr[data-id='#{violation.id}']" do
          assert_select "td a[href='#{violation_path(violation.id)}']", text: violation.case_number.to_s
        end
      end
    end
  end

end
