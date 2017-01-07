require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesController do
  include RequestSpecHelper

  context '#create' do

  end

  context '#index' do

    it 'entry returns correct published entries' do
      entry = create(:entry_with_creator)
      published_entry_a = create(:published_entry, entry: entry)
      published_entry_b = create(:published_entry, entry: entry)
      published_entry_c = create(:published_entry)

      get blog_v1_entry_published_entries_path(entry_id: entry.id), format: :json
      expect(response).to have_http_status(:success)
      order = [published_entry_a.id, published_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'domain returns correct published entries' do
      domain = create(:domain)
      published_entry_a = create(:published_entry, domain: domain)
      published_entry_b = create(:published_entry, domain: domain)
      published_entry_c = create(:published_entry)

      get blog_v1_domain_published_entries_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      order = [published_entry_a.id, published_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'group returns correct published entries' do
      group = create(:group)
      published_entry_a = create(:published_entry, domain: group.domain)
      published_entry_b = create(:published_entry, domain: group.domain)
      published_entry_c = create(:published_entry, domain: group.domain)

      group.published_entries << published_entry_b
      group.published_entries << published_entry_c

      get blog_v1_group_published_entries_path(group_id: group.id), format: :json
      expect(response).to have_http_status(:success)
      order = [published_entry_b.id, published_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

  it 'topic returns correct published entries' do
    topic = create(:topic)
    published_entry_a = create(:published_entry, domain: topic.domain)
    published_entry_b = create(:published_entry, domain: topic.domain)
    published_entry_c = create(:published_entry, domain: topic.domain)

    topic.published_entries << published_entry_b
    topic.published_entries << published_entry_c

    get blog_v1_topic_published_entries_path(topic_id: topic.id), format: :json
    expect(response).to have_http_status(:success)
    order = [published_entry_b.id, published_entry_c.id]
    expect(assigns(:records).pluck('id')).to match(order)
  end

end
