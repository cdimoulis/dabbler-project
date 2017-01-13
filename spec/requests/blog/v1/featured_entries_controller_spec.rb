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
      featured_entry = attributes_for(:featured_entry, entry: nil, author: nil, creator: admin)
      post blog_v1_entry_featured_entries_path(entry_id: entry.id), featured_entry: featured_entry, format: :json
      expect(response).to have_http_status(:success)
      expect(entry.id).to eq(assigns(:record).entry_id)
    end
  end

  context '#index' do

    it 'entry returns correct featured entries' do
      entry = create(:entry_with_creator)
      featured_entry_a = create(:featured_entry, entry: entry)
      featured_entry_b = create(:featured_entry, entry: entry)
      featured_entry_c = create(:featured_entry)

      get blog_v1_entry_featured_entries_path(entry_id: entry.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_a.id, featured_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'domain returns correct featured entries' do
      domain = create(:domain)
      featured_entry_a = create(:featured_entry, domain: domain)
      featured_entry_b = create(:featured_entry, domain: domain)
      featured_entry_c = create(:featured_entry)

      get blog_v1_domain_featured_entries_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_a.id, featured_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'group returns correct featured entries' do
      group = create(:group)
      other_group = create(:group)
      featured_entry_a = create(:featured_entry, domain: group.domain)
      featured_entry_b = create(:featured_entry, domain: group.domain)
      featured_entry_c = create(:featured_entry, domain: group.domain)
      other_entry = create(:featured_entry, domain: other_group.domain)

      group.featured_entries << featured_entry_b
      group.featured_entries << featured_entry_c
      other_group.featured_entries << other_entry

      get blog_v1_group_featured_entries_path(group_id: group.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_b.id, featured_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'featured group returns correct featured entries' do
      group = create(:featured_group)
      other_group = create(:featured_group)
      featured_entry_a = create(:featured_entry, domain: group.domain)
      featured_entry_b = create(:featured_entry, domain: group.domain)
      featured_entry_c = create(:featured_entry, domain: group.domain)
      other_entry = create(:featured_entry, domain: other_group.domain)

      group.featured_entries << featured_entry_b
      group.featured_entries << featured_entry_c
      other_group.featured_entries << other_entry

      get blog_v1_featured_group_featured_entries_path(featured_group_id: group.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_b.id, featured_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'topic returns correct featured entries' do
      topic = create(:topic)
      other_topic = create(:topic)
      featured_entry_a = create(:featured_entry, domain: topic.domain)
      featured_entry_b = create(:featured_entry, domain: topic.domain)
      featured_entry_c = create(:featured_entry, domain: topic.domain)
      other_entry = create(:featured_entry, domain: other_topic.domain)

      topic.featured_entries << featured_entry_b
      topic.featured_entries << featured_entry_c
      other_topic.featured_entries << other_entry

      get blog_v1_topic_featured_entries_path(topic_id: topic.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_b.id, featured_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

end
