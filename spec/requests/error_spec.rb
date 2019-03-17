require 'rails_helper'

RSpec.describe 'Error requests' do
  describe 'GET /404' do
    it 'returns a 404 page' do
      get('/404')
      expect(response.status).to eq(404)
    end
  end
  describe 'GET /401' do
    it 'returns a 401 page' do
      get('/401')
      expect(response.status).to eq(401)
    end
  end
end
