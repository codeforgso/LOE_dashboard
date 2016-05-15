require 'rails_helper'

RSpec.describe ViolationsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/violations').to route_to('violations#index')
    end

    it 'routes to #show' do
      expect(get: '/violations/1').to route_to('violations#show', id: '1')
    end

  end
end
