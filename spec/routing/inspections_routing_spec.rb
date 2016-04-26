require 'rails_helper'

RSpec.describe InspectionsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/inspections').to route_to('inspections#index')
    end

    it 'routes to #show' do
      expect(get: '/inspections/1').to route_to('inspections#show', id: '1')
    end

  end
end
