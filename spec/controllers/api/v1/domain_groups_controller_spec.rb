require "rails_helper"

RSpec.describe Api::V1::DomainGroupsController do

  # tests for CREATE route
  context "#create" do
    before do
      sign_in
    end

    it 'errors - no data' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'succeeds' do
      current = Domain.count
      domain_group = build(:domain_group)
      post :create, domain_group: domain_group.attributes, format: :json
      expect(response).to have_http_status(:success)
      expect(Domain.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:fly) {create(:domain_group, text: 'Fly Group')}
    let!(:hotel) {create(:domain_group, text: 'Hotel Group')}

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      # body_as_json found in support/helpers.rb
      expect(body_as_json).to match([fly.attributes,hotel.attributes])
    end

    it { expect(assigns(:records).count).to eq(2) }

  end

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:fly) { create(:domain_group, text: "Fly Group") }

    # Before running a test do this
    before do
      get :show, id: fly.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      # body_as_json found in support/helpers.rb
      expect(body_as_json).to match(fly.attributes)
    end

    it { expect(assigns(:record)).to eq(fly) }

  end

  # Test for UPDATE route
  context "#update" do
    # Allow travel to be shared across all tests
    let!(:travel) { create(:domain, text: "Travel") }
    let!(:hotel) { create(:domain_group, text: 'Hotel Group', domain: travel) }

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {description: "Hotel entries in Travel"}
      put :update, id: hotel.id, domain_group: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "prevents invalid updates" do
      fly = create(:domain_group, text: 'Fly Group', domain: travel)
      update_params = {text: "Hotel Group"}
      put :update, id: fly.id, domain_group: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for UPDATE route
  context "#destroy" do
    # Allow travel to be shared across all tests
    let!(:travel) { create(:domain, text: "Travel") }
    let!(:hotel) { create(:domain_group, text: 'Hotel Group', domain: travel) }
    let!(:current) { DomainGroup.count }

    before do
      sign_in
      delete :destroy, id: hotel.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(DomainGroup.count).to eq(current-1)
    end
  end
end
