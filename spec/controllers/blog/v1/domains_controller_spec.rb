require "rails_helper"

RSpec.describe Blog::V1::DomainsController do

  # tests for CREATE route
  context "#create" do
    let!(:current_user) { sign_in }
    # Need to act like the application controller set the current_user
    # Clearance sign_in does not call controller hooks
    before do
      Thread.current[:user] = current_user
    end

    it 'errors without data' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'succeeds' do
      current = Domain.count
      domain = attributes_for(:domain, creator: nil)
      post :create, domain: domain, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).creator_id).to eq(current_user.id)
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
      order = [code, travel]
      expect(assigns(:records).to_a).to match(order)
    end
  end

  # Tests for SHOW route
  context "#show" do
    let!(:travel) { create(:domain, text: "Travel") }

    # Before running a test do this
    before do
      get :show, id: travel.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it { expect(assigns(:record)).to eq(travel) }
  end

  # Test for UPDATE route
  context "#update" do
    before do
      sign_in
    end

    let!(:code) { create(:domain, text: "Code") }

    it "succeeds" do
      update_params = {description: "Programming related entries"}
      put :update, id: code.id, domain: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "updates menu_ordering" do
      update_params = {menu_ordering: ['created_at:asc', 'text:desc']}
      put :update, id: code.id, domain: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).menu_ordering).to eq(update_params[:menu_ordering])
    end

    it "prevents invalid updates" do
      travel = create(:domain, text: "Travel")
      update_params = {text: "Code"}
      put :update, id: travel.id, domain: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end
end
