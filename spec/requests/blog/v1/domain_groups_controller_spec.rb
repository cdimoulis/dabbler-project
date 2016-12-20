require "rails_helper"

RSpec.describe Blog::V1::DomainGroupsController do
  include RequestSpecHelper

  # Test nested creates
  context '#create' do
    let!(:travel) { create(:domain, text: 'Travel') }
    let(:group_via_domain_path) { blog_v1_domain_groups_path(domain_id: travel.id) }
    let(:create_params) { {text: "Fly Group", description: "Fly domain group", type: "DomainGroup"} }
    let!(:user) { create(:user) }

    before do
      full_sign_in user, '12345678'
    end

    after do
      full_sign_out
    end

    it "succeeds via domain" do
      post group_via_domain_path, group: create_params, format: :json
      expect(response).to have_http_status(:success)
      expect(travel.groups.count).to eq(1)
      expect(DomainGroup.first.domain.id).to eq(travel.id)
    end
  end

  # test nested index
  context '#index' do
    let!(:travel) { create(:domain_with_groups, text: 'Travel') }
    let(:groups_via_domain_path) { blog_v1_domain_groups_path(domain_id: travel.id) }

    it "fetches via domain" do
      get groups_via_domain_path, format: :json
      expect(response).to have_http_status(:success)
      expect(travel.groups.count).to eq(5)
    end
  end
end
