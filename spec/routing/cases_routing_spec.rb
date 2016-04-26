require 'rails_helper'

RSpec.describe CasesController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/cases').to route_to('cases#index')
    end

    it 'routes to #show' do
      expect(get: '/cases/1').to route_to('cases#show', id: '1')
    end

    it 'routes to #autocomplete' do
      expect(get: '/cases/autocomplete').to route_to('cases#autocomplete')
    end

  end
end
