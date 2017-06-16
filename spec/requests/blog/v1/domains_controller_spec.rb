require 'rails_helper'

RSpec.describe Blog::V1::DomainsController do
  include RequestSpecHelper

  context '#single_index' do
    let!(:domain) { create(:domain) }

    it 'returns correct domain for menu_group' do
      menu_group = create(:menu_group, domain: domain)
      get blog_v1_menu_group_domain_path(menu_group_id: menu_group.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

    it 'returns correct domain for topic' do
      topic = create(:topic, domain: domain)
      get blog_v1_topic_domain_path(topic_id: topic.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

    it 'returns correct domain for published_entry' do
      published_entry = create(:published_entry, domain: domain)
      get blog_v1_published_entry_domain_path(published_entry_id: published_entry.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

    it 'returns correct domain for featured_entry' do
      featured_entry = create(:featured_entry, domain: domain)
      get blog_v1_featured_entry_domain_path(featured_entry_id: featured_entry.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

  end
end
