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

  # Tests for INDEX route
  context "#index" do
    let!(:menu_group_a) {create(:menu_group)}
    let!(:menu_group_b) {create(:menu_group)}

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [menu_group_a, menu_group_b]
      expect(assigns(:records).to_a).to match(order)
    end

  end

  # Test for UPDATE route
  context "#update" do
    let!(:menu) { create(:menu, text: "Travel") }
    let!(:menu_group) { create(:menu_group, text: 'Hotel Group', menu: menu) }

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {description: "Hotel entries in Travel"}
      put :update, id: menu_group.id, menu_group: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "updates topic_ordering" do
      update_params = {topic_ordering: ['created_at:asc', 'text:desc']}
      put :update, id: menu_group.id, menu_group: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).topic_ordering).to eq(update_params[:topic_ordering])
    end

    it "prevents invalid updates" do
      dup = create(:menu_group, menu: menu)
      update_params = {text: menu_group.text}
      put :update, id: dup.id, menu_group: update_params, format: :json
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
