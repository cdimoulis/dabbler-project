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
    let!(:fly) {create(:featured_group, text: 'Fly Group')}
    let!(:hotel) {create(:tutorial_group, text: 'Hotel Group')}
    let!(:menu) {create(:menu_group, text: 'Menu Group')}

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
      expect(assigns(:records).to_a).to match([menu,tg_b,tg_c,tg_a])
    end

  end

  # Tests for SHOW route
  context "#show" do
    let!(:menu) { create(:menu_group, text: "Menu Group") }

    # Before running a test do this
    before do
      get :show, id: menu.id, format: :json
    end

    it { expect(assigns(:record)).to eq(menu) }

  end

end
