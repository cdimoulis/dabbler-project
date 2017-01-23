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

    it "fetches via featured_entry" do
      featured_entry = create(:featured_entry)
      group_a = create(:featured_group, domain: featured_entry.domain)
      group_b = create(:featured_group, domain: featured_entry.domain)
      group_c = create(:featured_group, domain: featured_entry.domain)
      featured_entry.groups << group_b
      featured_entry.groups << group_c
      route = blog_v1_featured_entry_featured_groups_path(featured_entry_id: featured_entry.id)
      get route, format: :json
      order = [group_b.id, group_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

  context '#single_index' do
    it 'fetches via topic' do
      group = create(:featured_group)
      topic = create(:topic, group: group, domain: group.domain)
      get blog_v1_topic_featured_group_path(topic_id: topic.id), format: :json
      expect(assigns(:record)).to eq(group)
    end
  end
end
