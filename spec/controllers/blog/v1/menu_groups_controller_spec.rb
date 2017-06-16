require 'rails_helper'

RSpec.describe Blog::V1::MenuGroupsController, type: :controller do

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
      current = MenuGroup.count
      menu_group = attributes_for(:menu_group)
      post :create, menu_group: menu_group, format: :json
      expect(response).to have_http_status(:success)
      expect(MenuGroup.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:menu_group) {create(:menu_group, text: 'Menu Group')}

    before do
      get :index, format: :json
    end

    it 'returns records of proper type' do
      expect(assigns(:records).length).to eq(1)
    end

    it 'orders correctly' do
      tg_a = create(:menu_group, domain: hotel.domain, order: 3)
      tg_b = create(:menu_group, domain: hotel.domain, order: 1)
      tg_c = create(:menu_group, domain: hotel.domain, order: 2)
      get :index, format: :json
      expect(assigns(:records).to_a).to match([menu_group,tg_b,tg_c,tg_a])
    end

  end

  # Tests for SHOW route
  context "#show" do
    let!(:menu_group) { create(:menu_group, text: "Menu Group") }

    # Before running a test do this
    before do
      get :show, id: menu_group.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it { expect(assigns(:record)).to eq(menu_group) }
  end


  # Test for UPDATE route
  context "#update" do
    let!(:travel) { create(:domain, text: "Travel") }
    let!(:hotel) { create(:menu_group, text: 'Hotel Group', domain: travel) }

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {description: "Hotel entries in Travel"}
      put :update, id: hotel.id, menu_group: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "prevents invalid updates" do
      fly = create(:menu_group, text: 'Fly Group', domain: travel)
      update_params = {text: "Hotel Group"}
      put :update, id: fly.id, menu_group: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:travel) { create(:domain, text: "Travel") }
    let!(:hotel) { create(:menu_group, text: 'Hotel Group', domain: travel) }
    let!(:current) { MenuGroup.count }

    before do
      sign_in
      delete :destroy, id: hotel.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(MenuGroup.count).to eq(current-1)
    end
  end

end
