require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe Api::V1::DomainsController do

  # tests for CREATE route
  context "#create" do
    it 'errors without data' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'succeeds' do
      current = Domain.count
      create(:domain)
      expect(Domain.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:travel) {create(:domain, text: 'Travel')}
    let!(:code) {create(:domain, text: 'Code')}

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      # body_as_json found in support/helpers.rb
      expect(body_as_json).to match([code.attributes,travel.attributes])
    end

    it { expect(assigns(:records).count).to eq(2) }

  end

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:travel) {create(:domain, text: "Travel")}

    # Before running a test do this
    before do
      get :show, id: travel.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      # body_as_json found in support/helpers.rb
      expect(body_as_json).to match(travel.attributes)
    end

    it { expect(assigns(:record)).to eq(travel) }

  end

  # Test for UPDATE route
  context "#update" do
    # Allow travel to be shared across all tests
    let!(:travel) {create(:domain, text: "Travel")}
    let!(:code) {create(:domain, text: "Code")}

    it "succeeds" do
      update_params = {description: "Travel related entries"}
      put :update, id: travel.id, domain: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "prevents invalid updates" do
      update_params = {text: "Code"}
      put :update, id: travel.id, domain: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

end
