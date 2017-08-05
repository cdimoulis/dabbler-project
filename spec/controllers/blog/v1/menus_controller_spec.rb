require 'rails_helper'

RSpec.describe Blog::V1::MenusController, type: :controller do

  # tests for CREATE route
  context "#create" do
    let!(:current_user) { sign_in }
    # Need to act like the application controller set the current_user
    # Clearance sign_in does not call controller hooks
    before do
      Thread.current[:user] = current_user
    end

    it 'errors - no data' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'succeeds' do
      current = Menu.count
      menu = attributes_for(:menu, creator: nil)
      post :create, menu: menu, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).creator_id).to eq(current_user.id)
      expect(Menu.count).to eq(current+1)
    end
  end

  # Tests for INDEX route
  context "#index" do
    let!(:menu_a) { create(:menu) }
    let!(:menu_b) { create(:menu) }

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [menu_a, menu_b]
      expect(assigns(:records).to_a).to match(order)
    end
  end

  # Tests for SHOW route
  context "#show" do
    let!(:menu) { create(:menu) }

    # Before running a test do this
    before do
      get :show, id: menu.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it { expect(assigns(:record)).to eq(menu) }
  end

  # Test for UPDATE route
  context "#update" do
    before do
      sign_in
    end

    let!(:menu) { create(:menu) }

    it "succeeds" do
      update_params = {description: "Some new information"}
      put :update, id: menu.id, menu: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "updates menu_group_ordering" do
      update_params = {menu_group_ordering: ['created_at:asc', 'text:desc']}
      put :update, id: menu.id, menu: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).menu_group_ordering).to eq(update_params[:menu_group_ordering])
    end

    it "prevents invalid updates" do
      dup = create(:menu, domain: menu.domain)
      update_params = {menu_group_ordering: ['created_at:asc', 'text:downy']}
      put :update, id: dup.id, menu: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:menu_1) { create(:menu) }
    let!(:menu_2) { create(:menu) }
    let!(:current) { Menu.count }

    before do
      sign_in
      delete :destroy, id: menu_2.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(Menu.count).to eq(current-1)
    end
  end
end
