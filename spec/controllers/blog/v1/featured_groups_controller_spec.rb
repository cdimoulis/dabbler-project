require "rails_helper"

RSpec.describe Blog::V1::FeaturedGroupsController do

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
      current = FeaturedGroup.count
      featured_group = attributes_for(:featured_group)
      post :create, featured_group: featured_group, format: :json
      expect(response).to have_http_status(:success)
      expect(FeaturedGroup.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:fly) {create(:featured_group, text: 'Fly Group')}
    let!(:hotel) {create(:tutorial_group, text: 'Hotel Group')}

    it 'returns only records of proper type' do
      get :index, format: :json
      expect(assigns(:records).length).to eq(1)
    end

    it 'orders correctly' do
      fg_a = create(:featured_group, domain: fly.domain, order: 3)
      fg_b = create(:featured_group, domain: fly.domain, order: 1)
      fg_c = create(:featured_group, domain: fly.domain, order: 2)
      get :index, format: :json
      expect(assigns(:records).to_a).to match([fly,fg_b,fg_c,fg_a])
    end

  end

  # Tests for SHOW route
  context "#show" do
    let!(:fly) { create(:featured_group, text: "Fly Group") }

    # Before running a test do this
    before do
      get :show, id: fly.id, format: :json
    end

    it { expect(assigns(:record)).to eq(fly) }

  end
end
