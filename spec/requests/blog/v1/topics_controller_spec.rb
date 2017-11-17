require "rails_helper"

RSpec.describe Blog::V1::TopicsController do
  include RequestSpecHelper

  # Test nested creates
  context '#create' do
    let!(:admin) { create(:user) }
    let!(:topic) { attributes_for(:topic_without_menu_group) }

    before do
      full_sign_in admin, '12345678'
    end

    after do
      full_sign_out
    end

    it "succeeds via menu_group" do
      menu_group = create(:menu_group)
      route = blog_v1_menu_group_topics_path(menu_group_id: menu_group.id)
      post route, topic: topic, format: :json
      expect(response).to have_http_status(:success)
      expect(menu_group.topics.count).to eq(1)
      expect(assigns(:record).menu_group_id).to eq(menu_group.id)
    end
  end

  # # test nested index
  context '#index' do
    let!(:topic) { create(:topic) }
  #
    it "fetches via domain" do
      # this will add 5 topics from :domain_with_topics. So 6 total
      domain = create(:domain_with_topics)
      get blog_v1_domain_topics_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      # :domain_with_topics factory creates 5 groups on default
      expect(assigns(:records).count).to eq(5)
    end

    it "fetches via menu" do
      # this will add 5 topics from :domain_with_topics. So 6 total
      menu = create(:menu_with_topics)
      get blog_v1_menu_topics_path(menu_id: menu.id), format: :json
      expect(response).to have_http_status(:success)
      # :menu_with_topics factory creates 5 groups on default
      expect(assigns(:records).count).to eq(5)
    end

    context "fetches via menu_group" do
      let!(:menu_group) { create(:menu_group) }

      context 'has ordering concern' do
        let!(:a) { create(:topic, menu_group: menu_group, text: 'A', order: nil) }
        let!(:b) { create(:topic, menu_group: menu_group, text: 'B', order: nil) }
        let!(:c) { create(:topic, menu_group: menu_group, text: 'C', order: 3) }
        let!(:d) { create(:topic, menu_group: menu_group, text: 'D', order: 2) }
        let!(:e) { create(:topic, menu_group: menu_group, text: 'E', order: 1) }
        let!(:f) { create(:topic, menu_group: menu_group, text: 'F', order: nil) }

        it 'orders correctly with default' do
          url = blog_v1_menu_group_topics_path(menu_group_id: menu_group.id)
          get url, format: :json
          ordered = [e,d,c,a,b,f]
          expect(assigns(:records).to_a).to match(ordered)
        end

        it 'orders correctly with text first' do
          menu_group.update_attribute(:topic_ordering, ['text:asc','order:asc'])
          f.update_attribute(:order, 4)
          b.update_attribute(:order, 5)
          a.update_attribute(:order, 6)
          url = blog_v1_menu_group_topics_path(menu_group_id: menu_group.id)
          get url, format: :json
          ordered = [a,b,c,d,e,f]
          expect(assigns(:records).to_a).to match(ordered)
        end
      end
    end
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
