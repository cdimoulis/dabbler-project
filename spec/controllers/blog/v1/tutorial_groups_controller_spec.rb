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
      tutorial_group = build(:tutorial_group)
      post :create, tutorial_group: tutorial_group.attributes, format: :json
      expect(response).to have_http_status(:success)
      expect(TutorialGroup.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:fly) {create(:published_group, text: 'Fly Group')}
    let!(:hotel) {create(:tutorial_group, text: 'Hotel Group')}

    before do
      get :index, format: :json
    end

    it 'returns records of proper type' do
      expect(assigns(:records).length).to eq(1)
    end

  end

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:fly) { create(:tutorial_group, text: "Fly Group") }

    # Before running a test do this
    before do
      get :show, id: fly.id, format: :json
    end

    it { expect(assigns(:record)).to eq(fly) }

  end
end
