require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe Api::V1::DomainsController do

  context "CREATE" do
    it 'does not create without data' do
      post :create
      expect(response).to have_http_status(422)
    end

  end

  context "GET" do
    # Allow travel to be shared across all tests
    let(:travel) {create(:domain, text: "Travel")}

    # Before running a test do this
    before do
      get :show, id: travel.id, format: :json
    end

    it 'returns success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns correct data' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      # body_as_json found in support/helpers.rb
      expect(body_as_json).to match(travel.attributes)
    end
  end


end
