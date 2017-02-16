require "rails_helper"

RSpec.describe Blog::V1::TutorialGroupsController do

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
      current = TutorialGroup.count
      tutorial_group = attributes_for(:tutorial_group)
      post :create, tutorial_group: tutorial_group, format: :json
      expect(response).to have_http_status(:success)
      expect(TutorialGroup.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:fly) {create(:featured_group, text: 'Fly Group')}
    let!(:hotel) {create(:tutorial_group, text: 'Hotel Group')}

    before do
      get :index, format: :json
    end

    it 'returns records of proper type' do
      expect(assigns(:records).length).to eq(1)
    end

    it 'orders correctly' do
      tg_a = create(:tutorial_group, domain: hotel.domain, order: 3)
      tg_b = create(:tutorial_group, domain: hotel.domain, order: 1)
      tg_c = create(:tutorial_group, domain: hotel.domain, order: 2)
      get :index, format: :json
      expect(assigns(:records).to_a).to match([hotel,tg_b,tg_c,tg_a])
    end

  end

  # Tests for SHOW route
  context "#show" do
    let!(:fly) { create(:tutorial_group, text: "Fly Group") }

    # Before running a test do this
    before do
      get :show, id: fly.id, format: :json
    end

    it { expect(assigns(:record)).to eq(fly) }

  end
end
