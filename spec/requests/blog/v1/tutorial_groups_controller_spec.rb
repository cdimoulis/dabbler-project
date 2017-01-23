require "rails_helper"

RSpec.describe Blog::V1::TutorialGroupsController do
  include RequestSpecHelper

  # Test nested creates
  context '#create' do
    let!(:travel) { create(:domain, text: 'Travel') }
    let(:tutorial_group_via_domain_path) { blog_v1_domain_tutorial_groups_path(domain_id: travel.id) }
    let(:create_params) { {text: "Fly Group", description: "Fly domain group"} }
    let!(:user) { create(:user) }

    before do
      full_sign_in user, '12345678'
    end

    after do
      full_sign_out
    end

    it "succeeds via domain" do
      post tutorial_group_via_domain_path, tutorial_group: create_params, format: :json
      expect(response).to have_http_status(:success)
      expect(travel.groups.count).to eq(1)
      expect(TutorialGroup.first.domain.id).to eq(travel.id)
    end
  end

  # test nested index
  context '#index' do
    let!(:travel) { create(:domain_with_tutorial_groups, text: 'Travel') }
    let(:tutorial_groups_via_domain_path) { blog_v1_domain_tutorial_groups_path(domain_id: travel.id) }

    it "fetches via domain" do
      get tutorial_groups_via_domain_path, format: :json
      expect(response).to have_http_status(:success)
      expect(travel.groups.count).to eq(5)
    end

    it "fetches via tutorial_entry" do
      tutorial_entry = create(:tutorial_entry)
      group_a = create(:tutorial_group, domain: tutorial_entry.domain)
      group_b = create(:tutorial_group, domain: tutorial_entry.domain)
      group_c = create(:tutorial_group, domain: tutorial_entry.domain)
      tutorial_entry.groups << group_b
      tutorial_entry.groups << group_c
      route = blog_v1_tutorial_entry_tutorial_groups_path(tutorial_entry_id: tutorial_entry.id)
      get route, format: :json
      order = [group_b.id, group_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end
end
