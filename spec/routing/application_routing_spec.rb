require 'rails_helper'

RSpec.describe ApplicationController, type: :routing do
  describe 'routing' do

    it 'routes to root' do
      expect(get: '/').to route_to('cases#index')
    end

    it 'routes to js_config' do
      expect(get: '/application/js_config').to route_to('application#js_config')
    end

  end
end
