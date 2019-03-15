require 'rails_helper'

RSpec.describe ShortenUrlsController, type: :controller do
  context 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_success # response.success?
    end
  end

  context 'POST #create' do
    let(:cookie) { JWT.decode(JSON.parse(response.body)['token'], key) }

    it 'returns a JWT with valid claims' do
      post :create
      expect(cookie['user_id']).to eq(123)
    end

    context "with valid attributes" do
      it "creates a new short url" do
        expect{
          post :create, contact: Factory.attributes_for(:contact)
        }.to change(Contact,:count).by(1)
      end

      it "redirects to the new contact" do
        post :create, contact: Factory.attributes_for(:contact)
        response.should redirect_to Contact.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new contact" do
        expect{
          post :create, contact: Factory.attributes_for(:invalid_contact)
        }.to_not change(Contact,:count)
      end

      it "re-renders the new method" do
        post :create, contact: Factory.attributes_for(:invalid_contact)
        response.should render_template :new
      end
    end

  end
  context 'GET #show' do
    before(:each) do
      controller.stub!(:authenticate_request => true)
    end
    it 'returns a success response' do
      url = ShortenUrl.create(original_url: 'https://google.com', short_url: 'qwe123', admin_url: 'qwe456').save
      get :show, params: { id: url.to_param }
      # expect(response.status).to eq(401)
      # expect(response).to be_success # response.success?
    end
  end
  context 'GET #edit' do
    it 'returns a success response' do
      url = ShortenUrl.create(original_url: 'https://google.com', short_url: 'qwe123', admin_url: 'qwe456')
      url.save
      get :edit, params: { id: url.to_param }
      expect(response).to be_success # response.success?
    end
  end

end
