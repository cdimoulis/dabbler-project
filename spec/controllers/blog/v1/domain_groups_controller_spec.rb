require "rails_helper"

RSpec.describe Blog::V1::DomainGroupsController do

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

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:fly) { create(:domain_group, text: "Fly Group") }

    # Before running a test do this
    before do
      get :show, id: fly.id, format: :json
    end

    it { expect(assigns(:record)).to eq(fly) }

  end
end
