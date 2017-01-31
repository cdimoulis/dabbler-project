require 'rails_helper'

RSpec.describe Blog::V1::TutorialEntriesController do
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
      tutorial_entry = attributes_for(:tutorial_entry, entry: nil, author: nil, creator: admin)
      post blog_v1_entry_tutorial_entries_path(entry_id: entry.id), tutorial_entry: tutorial_entry, format: :json
      expect(response).to have_http_status(:success)
      expect(entry.id).to eq(assigns(:record).entry_id)
    end
  end

  context '#index' do

    it 'entry returns correct tutorial entries' do
      entry = create(:entry_with_creator)
      tutorial_entry_a = create(:tutorial_entry, entry: entry, data: {order: 1})
      tutorial_entry_b = create(:tutorial_entry, entry: entry, data: {order: 2})
      tutorial_entry_c = create(:tutorial_entry, data: {order: 3})

      get blog_v1_entry_tutorial_entries_path(entry_id: entry.id), format: :json
      expect(response).to have_http_status(:success)
      order = [tutorial_entry_a.id, tutorial_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'domain returns correct tutorial entries' do
      domain = create(:domain)
      tutorial_entry_a = create(:tutorial_entry, domain: domain, data: {order: 1})
      tutorial_entry_b = create(:tutorial_entry, domain: domain, data: {order: 2})
      tutorial_entry_c = create(:tutorial_entry, data: {order: 3})

      get blog_v1_domain_tutorial_entries_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      order = [tutorial_entry_a.id, tutorial_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'group returns correct tutorial entries' do
      group = create(:tutorial_group)
      other_group = create(:tutorial_group)
      tutorial_entry_a = create(:tutorial_entry, domain: group.domain, data: {order: 1})
      tutorial_entry_b = create(:tutorial_entry, domain: group.domain, data: {order: 2})
      tutorial_entry_c = create(:tutorial_entry, domain: group.domain, data: {order: 3})
      other_entry = create(:tutorial_entry, domain: other_group.domain, data: {order: 4})

      group.tutorial_entries << tutorial_entry_b
      group.tutorial_entries << tutorial_entry_c
      other_group.tutorial_entries << other_entry

      get blog_v1_group_tutorial_entries_path(group_id: group.id), format: :json
      expect(response).to have_http_status(:success)
      order = [tutorial_entry_b.id, tutorial_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'tutorial group returns correct tutorial entries' do
      group = create(:tutorial_group)
      other_group = create(:tutorial_group)
      tutorial_entry_a = create(:tutorial_entry, domain: group.domain, data: {order: 1})
      tutorial_entry_b = create(:tutorial_entry, domain: group.domain, data: {order: 2})
      tutorial_entry_c = create(:tutorial_entry, domain: group.domain, data: {order: 3})
      other_entry = create(:tutorial_entry, domain: other_group.domain, data: {order: 4})

      group.tutorial_entries << tutorial_entry_b
      group.tutorial_entries << tutorial_entry_c
      other_group.tutorial_entries << other_entry

      get blog_v1_tutorial_group_tutorial_entries_path(tutorial_group_id: group.id), format: :json
      expect(response).to have_http_status(:success)
      order = [tutorial_entry_b.id, tutorial_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'topic returns correct tutorial entries' do
      domain = create(:domain)
      group = create(:tutorial_group, domain: domain)
      topic = create(:topic, group: group, domain: group.domain)
      other_topic = create(:topic, group: group, domain: group.domain)
      tutorial_entry_a = create(:tutorial_entry, domain: topic.domain, data: {order: 1})
      tutorial_entry_b = create(:tutorial_entry, domain: topic.domain, data: {order: 2})
      tutorial_entry_c = create(:tutorial_entry, domain: topic.domain, data: {order: 3})
      other_entry = create(:tutorial_entry, domain: other_topic.domain, data: {order: 4})

      topic.tutorial_entries << tutorial_entry_b
      topic.tutorial_entries << tutorial_entry_c
      other_topic.tutorial_entries << other_entry

      get blog_v1_topic_tutorial_entries_path(topic_id: topic.id), format: :json
      expect(response).to have_http_status(:success)
      order = [tutorial_entry_b.id, tutorial_entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end
end
