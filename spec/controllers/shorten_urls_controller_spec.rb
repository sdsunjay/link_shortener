require 'rails_helper'

RSpec.describe ShortenUrlsController, type: :controller do
  context 'GET #new' do
    it 'returns a success response' do
      get :new
      # Use RSpec magic matching
      expect(response).to be_successful
    end
  end

  context 'GET #admin_send_to_url' do

    context 'Without valid record' do
      it 'returns a 401' do
        get :admin_send_to_url, params: { admin_url: "ts0Jmd" }
        # Use RSpec magic matching
        expect(response).to redirect_to '/401'
      end

    end

    context 'With cookie' do
      it 'returns a 200' do
        short = ShortenUrl.create(original_url: 'https://google.com')
        get :admin_send_to_url, params: { admin_url: short.admin_url }
        expect(assigns(:url)).to eq(short)
        expect(response).to redirect_to short
        # expect(response.cookies[:jwt]).to eq(short.id)
      end

    end

  end # close admin_send_to_url

  context 'GET #show' do

    context 'Without cookie' do
      it 'returns a 401' do
        short = ShortenUrl.create(original_url: 'https://google.com')
        get :show, params: { id: short.id }
        expect(response).to redirect_to '/401'
      end

    end

    context 'With cookie' do
      it 'returns a 200' do
        short = ShortenUrl.create(original_url: 'https://google.com')
        get :admin_send_to_url, params: { admin_url: short.admin_url }
        get :show, params: { id: short.id }
        expect(response.status).to eq(200)
      end
    end
  end # close #show

  context 'GET #edit' do
      it 'Without cookie' do
        short = ShortenUrl.create(original_url: 'https://google.com')
        get :edit, params: { id: short.id }
        expect(response).to redirect_to '/401'
      end
  end # close #edit

end
