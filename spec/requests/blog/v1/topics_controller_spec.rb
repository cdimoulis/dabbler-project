require "rails_helper"

RSpec.describe Blog::V1::TopicsController do
  include RequestSpecHelper

  # Test nested creates
  # context '#create' do
  #   let!(:domain) { create(:domain) }
  #   let!(:topic) { attributes_for(:topic_without_menu_group, domain: domain) }
  #   let!(:user) { create(:user) }
  #
  #   before do
  #     full_sign_in user, '12345678'
  #   end
  #
  #   after do
  #     full_sign_out
  #   end
  #
  #   it "succeeds via menu_group" do
  #     menu_group = create(:menu_group, domain: domain)
  #     route = blog_v1_menu_group_topics_path(menu_group_id: menu_group.id)
  #     post route, topic: topic, format: :json
  #     expect(response).to have_http_status(:success)
  #     expect(domain.topics.count).to eq(1)
  #     expect(Topic.first.menu_group.id).to eq(menu_group.id)
  #   end
  # end

  # # test nested index
  context '#index' do
  #   let!(:topic) { create(:topic) }
  #
    it "fetches via domain" do
      domain = create(:domain_with_topics)
      # create one more MenuGroup to add more than 5 from :domain_with_topics
      topic = create(:topic)
      get blog_v1_domain_topics_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      # :domain_with_topics factory creates 5 groups on default
      expect(assigns(:records).count).to eq(5)
    end
  #
  #   it "fetches via menu_group" do
  #     menu_group = topic.menu_group
  #     topic_b = create(:topic, domain: topic.domain, menu_group: menu_group)
  #     topic_c = create(:topic)
  #     route = blog_v1_menu_group_topics_path(menu_group_id: menu_group.id)
  #     get route, format: :json
  #     order = [topic.id, topic_b.id]
  #     expect(assigns(:records).pluck('id')).to match(order)
  #   end
  #
  #   it "fetches via published_entry" do
  #     menu_group = topic.menu_group
  #     published_entry = create(:published_entry, domain: topic.domain)
  #     topic_b = create(:topic, domain: topic.domain, menu_group: menu_group)
  #     topic_c = create(:topic, domain: topic.domain, menu_group: menu_group)
  #     published_entry.topics << topic_b
  #     published_entry.topics << topic_c
  #     route = blog_v1_published_entry_topics_path(published_entry_id: published_entry.id)
  #     get route, format: :json
  #     order = [topic_b.id, topic_c.id]
  #     expect(assigns(:records).pluck('id')).to match(order)
  #   end
  #
  #   it "fetches via featured_entry" do
  #     group = topic.group
  #     featured_entry = create(:featured_entry, domain: topic.domain)
  #     topic_b = create(:topic, domain: topic.domain, group: group)
  #     topic_c = create(:topic, domain: topic.domain, group: group)
  #     featured_entry.topics << topic_b
  #     featured_entry.topics << topic_c
  #     route = blog_v1_featured_entry_topics_path(featured_entry_id: featured_entry.id)
  #     get route, format: :json
  #     order = [topic_b.id, topic_c.id]
  #     expect(assigns(:records).pluck('id')).to match(order)
  #   end
  end

  # Valid child ordering attribute
  context "VALID_CHILD_ORDERING_ATTRIBUTES" do
    let!(:topic) { create(:topic) }

    it "get correct values" do
      get blog_v1_topic_child_orderings_path(topic_id: topic.id), format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(Topic.VALID_CHILD_ORDERING_ATTRIBUTES)
    end
  end
end
