require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesController do
  include RequestSpecHelper

  context '#create' do

  end

  context '#index' do
    let!(:entry) { create(:entry_with_creator) }
    let!(:published_entry_a) { create(:published_entry, entry: entry) }
    let!(:published_entry_b) { create(:published_entry, entry: entry) }
    let!(:published_entry_c) { create(:published_entry) }

    it 'entry returns correct published entries' do
      get blog_v1_entry_published_entries_path(entry_id: entry.id), format: :json
      expect(response).to have_http_status(:success)
      order = [published_entry_a.id, published_entry_b.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

end
