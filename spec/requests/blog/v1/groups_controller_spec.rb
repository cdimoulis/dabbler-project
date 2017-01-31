require "rails_helper"

RSpec.describe Blog::V1::GroupsController do
  include RequestSpecHelper

  context '#create' do
    let!(:user) { create(:user) }

    before do
      full_sign_in user, '12345678'
    end

    after do
      full_sign_out
    end

    it "succeeds via domain" do
      group = attributes_for(:group)
      domain = Domain.find(group[:domain_id])
      post blog_v1_domain_groups_path(domain_id: domain.id), group: group, format: :json
      expect(response).to have_http_status(:success)
      expect(domain.groups.count).to eq(1)
      expect(Group.first.domain.id).to eq(domain.id)
    end
  end

  context '#index' do
    it "fetches via domain" do
      domain = create(:domain_with_groups)
      get blog_v1_domain_groups_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      expect(domain.groups.count).to eq(5)
    end

    it "fetches via published_entry" do
      published_entry = create(:published_entry)
      group_a = create(:featured_group, domain: published_entry.domain)
      group_b = create(:featured_group, domain: published_entry.domain)
      group_c = create(:tutorial_group, domain: published_entry.domain)
      published_entry.groups << group_b
      published_entry.groups << group_c
      route = blog_v1_published_entry_groups_path(published_entry_id: published_entry.id)
      get route, format: :json
      order = [group_b.id, group_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

  context '#single_index' do
    it 'fetches via topic' do
      group = create(:featured_group)
      topic = create(:topic, group: group, domain: group.domain)
      get blog_v1_topic_group_path(topic_id: topic.id), format: :json
      expect(assigns(:record)).to eq(group)
    end
  end
end
