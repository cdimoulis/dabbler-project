require 'rails_helper'

RSpec.describe Blog::V1::DomainsController do
  include RequestSpecHelper

  context '#single_index' do
    let!(:domain) { create(:domain) }

    it 'returns correct domain for group' do
      group = create(:group, domain: domain)
      get blog_v1_group_domain_path(group_id: group.id), format: :json
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

  end
end
