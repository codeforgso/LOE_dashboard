require 'rails_helper'

RSpec.describe "layouts/application", type: :view do

  describe 'application layout' do
    it "renders application layout" do
      render
      assert_select "header.main > a[href='#{root_path}']", text: 'Home'
      assert_select "header.main > a[href='#{pages_path}']", text: 'About'
    end
  end

end