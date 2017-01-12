require "rails_helper"

RSpec.describe Blog::V1::FeaturedGroupsController do
  include RequestSpecHelper

  # Test nested creates
  context '#create' do
    let!(:travel) { create(:domain, text: 'Travel') }
    let(:featured_group_via_domain_path) { blog_v1_domain_featured_groups_path(domain_id: travel.id) }
    let(:create_params) { {text: "Fly Group", description: "Fly domain group"} }
    let!(:user) { create(:user) }

    before do
      full_sign_in user, '12345678'
    end

    after do
      full_sign_out
    end

    it "succeeds via domain" do
      post featured_group_via_domain_path, featured_group: create_params, format: :json
      expect(response).to have_http_status(:success)
      expect(travel.groups.count).to eq(1)
      expect(FeaturedGroup.first.domain.id).to eq(travel.id)
    end
  end

  # test nested index
  context '#index' do
    it "fetches via domain" do
      domain = create(:domain_with_groups)
      get blog_v1_domain_groups_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      expect(domain.groups.count).to eq(5)
    end
  end
end
