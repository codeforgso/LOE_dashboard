require 'rails_helper'

RSpec.describe ApplicationController, type: :routing do
  describe 'routing' do

    it 'routes to root' do
      expect(get: '/').to route_to('pages#index')
    end

  end
end
