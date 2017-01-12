require 'rails_helper'

RSpec.describe Blog::V1::FeaturedEntriesController do
  include RequestSpecHelper

  context '#create' do
    let!(:admin) { create(:user) }

    before do
      full_sign_in admin, '12345678'
    end

    after do
      full_sign_out
    end

    it 'creates via entries' do
      entry = create(:entry_with_creator)
      featured_entry = build(:featured_entry, entry: nil, author: nil, creator: admin)
      post blog_v1_entry_featured_entries_path(entry_id: entry.id), featured_entry: featured_entry.attributes, format: :json
      expect(response).to have_http_status(:success)
      expect(entry.id).to eq(assigns(:record).entry_id)
    end
  end

  context '#index' do

    it 'entry returns correct published entries' do
      entry = create(:entry_with_creator)
      featured_entry_a = create(:featured_entry, entry: entry)
      featured_entry_b = create(:featured_entry, entry: entry)
      featured_entry_c = create(:featured_entry)

      get blog_v1_entry_featured_entries_path(entry_id: entry.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_a.id, featured_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'domain returns correct published entries' do
      domain = create(:domain)
      featured_entry_a = create(:featured_entry, domain: domain)
      featured_entry_b = create(:featured_entry, domain: domain)
      featured_entry_c = create(:featured_entry)

      get blog_v1_domain_featured_entries_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_a.id, featured_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'group returns correct published entries' do
      group = create(:group)
      featured_entry_a = create(:featured_entry, domain: group.domain)
      featured_entry_b = create(:featured_entry, domain: group.domain)
      featured_entry_c = create(:featured_entry, domain: group.domain)
      tutorial_entry = create(:tutorial_entry, domain: group.domain)

      group.featured_entries << featured_entry_b
      group.featured_entries << featured_entry_c
      group.tutorial_entries << tutorial_entry

      get blog_v1_group_featured_entries_path(group_id: group.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_b.id, featured_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'topic returns correct published entries' do
      topic = create(:topic)
      featured_entry_a = create(:featured_entry, domain: topic.domain)
      featured_entry_b = create(:featured_entry, domain: topic.domain)
      featured_entry_c = create(:featured_entry, domain: topic.domain)
      tutorial_entry = create(:tutorial_entry, domain: topic.domain)

      topic.featured_entries << featured_entry_b
      topic.featured_entries << featured_entry_c
      topic.tutorial_entries << tutorial_entry

      get blog_v1_topic_featured_entries_path(topic_id: topic.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_b.id, featured_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

end
