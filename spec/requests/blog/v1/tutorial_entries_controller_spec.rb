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

    it 'entry returns correct featured entries' do
      entry = create(:entry_with_creator)
      featured_entry_a = create(:featured_entry, entry: entry, data: {published_at: (DateTime.now - 1.days).strftime})
      featured_entry_b = create(:featured_entry, entry: entry, data: {published_at: (DateTime.now - 2.days).strftime})
      featured_entry_c = create(:featured_entry, data: {published_at: (DateTime.now - 1.days).strftime})

      get blog_v1_entry_featured_entries_path(entry_id: entry.id), format: :json
      expect(response).to have_http_status(:success)
      order = [featured_entry_a.id, featured_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end
end
