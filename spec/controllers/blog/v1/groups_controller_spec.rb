require "rails_helper"

RSpec.describe Blog::V1::GroupsController do

  # Tests for INDEX route
  context "#index" do
    let!(:fly) {create(:group, text: 'Fly Group')}
    let!(:hotel) {create(:group, text: 'Hotel Group')}

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [fly.id, hotel.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

  end

  # Tests for SHOW route
  context "#show" do
    
    let!(:fly) { create(:group, text: "Fly Group") }

    # Before running a test do this
    before do
      get :show, id: fly.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

  end

  # Test for UPDATE route
  context "#update" do
    let!(:travel) { create(:domain, text: "Travel") }
    let!(:hotel) { create(:group, text: 'Hotel Group', domain: travel) }

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {description: "Hotel entries in Travel"}
      put :update, id: hotel.id, group: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "prevents invalid updates" do
      fly = create(:group, text: 'Fly Group', domain: travel)
      update_params = {text: "Hotel Group"}
      put :update, id: fly.id, group: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:travel) { create(:domain, text: "Travel") }
    let!(:hotel) { create(:group, text: 'Hotel Group', domain: travel) }
    let!(:current) { Group.count }

    before do
      sign_in
      delete :destroy, id: hotel.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(Group.count).to eq(current-1)
    end
  end
end
