require "rails_helper"

RSpec.describe Blog::V1::TopicsController do
  include RequestSpecHelper

  # Test nested creates
  context '#create' do
    let!(:domain) { create(:domain) }
    let!(:topic) { attributes_for(:topic_without_group, domain: domain) }
    let!(:user) { create(:user) }

    before do
      full_sign_in user, '12345678'
    end

    after do
      full_sign_out
    end

    it "succeeds via group" do
      group = create(:group, domain: domain)
      route = blog_v1_group_topics_path(group_id: group.id)
      post route, topic: topic, format: :json
      expect(response).to have_http_status(:success)
      expect(domain.topics.count).to eq(1)
      expect(Topic.first.group.id).to eq(group.id)
    end

    it "succeeds via featured_group" do
      group = create(:featured_group, domain: domain)
      route = blog_v1_featured_group_topics_path(featured_group_id: group.id)
      post route, topic: topic, format: :json
      expect(response).to have_http_status(:success)
      expect(domain.topics.count).to eq(1)
      expect(Topic.first.group.id).to eq(group.id)
    end

    it "succeeds via tutorial_group" do
      group = create(:tutorial_group, domain: domain)
      route = blog_v1_tutorial_group_topics_path(tutorial_group_id: group.id)
      post route, topic: topic, format: :json
      expect(response).to have_http_status(:success)
      expect(domain.topics.count).to eq(1)
      expect(Topic.first.group.id).to eq(group.id)
    end

  end

  # test nested index
  context '#index' do
    let!(:topic) { create(:topic) }

    it "fetches via domain" do
      group = create(:group, domain: topic.domain)
      topic_b = create(:topic, domain: topic.domain, group: group)
      topic_c = create(:topic)
      route = blog_v1_domain_topics_path(domain_id: topic.domain_id)
      get route, format: :json
      order = [topic.id, topic_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it "fetches via group" do
      group = topic.group
      topic_b = create(:topic, domain: topic.domain, group: group)
      topic_c = create(:topic)
      route = blog_v1_group_topics_path(group_id: group.id)
      get route, format: :json
      order = [topic.id, topic_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it "fetches via featured_group" do
      group = topic.group
      topic_b = create(:topic, domain: topic.domain, group: group)
      topic_c = create(:topic)
      route = blog_v1_featured_group_topics_path(featured_group_id: group.id)
      get route, format: :json
      order = [topic.id, topic_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it "fetches via tutorial_group" do
      group = create(:tutorial_group)
      topic_b = create(:topic, domain: group.domain, group: group)
      topic_c = create(:topic, domain: group.domain, group: group)
      route = blog_v1_tutorial_group_topics_path(tutorial_group_id: group.id)
      get route, format: :json
      order = [topic_b.id, topic_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it "fetches via published_entry" do
      group = topic.group
      published_entry = create(:published_entry, domain: topic.domain)
      topic_b = create(:topic, domain: topic.domain, group: group)
      topic_c = create(:topic, domain: topic.domain, group: group)
      published_entry.topics << topic_b
      published_entry.topics << topic_c
      route = blog_v1_published_entry_topics_path(published_entry_id: published_entry.id)
      get route, format: :json
      order = [topic_b.id, topic_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it "fetches via featured_entry" do
      group = topic.group
      featured_entry = create(:featured_entry, domain: topic.domain)
      topic_b = create(:topic, domain: topic.domain, group: group)
      topic_c = create(:topic, domain: topic.domain, group: group)
      featured_entry.topics << topic_b
      featured_entry.topics << topic_c
      route = blog_v1_featured_entry_topics_path(featured_entry_id: featured_entry.id)
      get route, format: :json
      order = [topic_b.id, topic_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it "fetches via tutorial_entry" do
      group = create(:tutorial_group)
      topic = create(:topic, domain: group.domain, group: group)
      tutorial_entry = create(:tutorial_entry, domain: topic.domain)
      topic_b = create(:topic, domain: topic.domain, group: group)
      topic_c = create(:topic, domain: topic.domain, group: group)
      tutorial_entry.topics << topic_b
      tutorial_entry.topics << topic_c
      route = blog_v1_tutorial_entry_topics_path(tutorial_entry_id: tutorial_entry.id)
      get route, format: :json
      order = [topic_b.id, topic_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end
end
