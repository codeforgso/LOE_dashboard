require 'rails_helper'

RSpec.describe CaseHistoriesController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/case_histories').to route_to('case_histories#index')
    end

    it 'routes to #show' do
      expect(get: '/case_histories/1').to route_to('case_histories#show', id: '1')
    end

  end
end
