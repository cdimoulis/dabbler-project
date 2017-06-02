require 'rails_helper'

RSpec.describe Blog::V1::EntriesController do
  include RequestSpecHelper

  context '#single_index' do
    let!(:entry) { create(:entry) }

    it 'returns correct entry for published_entry' do
      published_entry = create(:published_entry, entry: entry)
      get blog_v1_published_entry_entry_path(published_entry_id: published_entry.id), format: :json
      expect(assigns(:record)).to eq(entry)
    end

    it 'returns correct entry for featured_entry' do
      featured_entry = create(:featured_entry, entry: entry)
      get blog_v1_featured_entry_entry_path(featured_entry_id: featured_entry.id), format: :json
      expect(assigns(:record)).to eq(entry)
    end

    it 'returns correct entry for tutorial_entry' do
      tutorial_entry = create(:tutorial_entry, entry: entry)
      get blog_v1_tutorial_entry_entry_path(tutorial_entry_id: tutorial_entry.id), format: :json
      expect(assigns(:record)).to eq(entry)
    end
  end

  context '#author' do
    let!(:author_a) { create(:user, email: 'a@dabbler.fyi') }
    let!(:author_b) { create(:user, email: 'b@dabbler.fyi') }
    let!(:entry) { create(:entry, author: author_a) }
    let(:author_via_entry_path) { blog_v1_entry_author_path(entry_id: entry.id) }

    it 'returns correct author for entry' do
      get author_via_entry_path, format: :json
      expect(assigns(:record)).to eq(author_a)
    end

  end

  context '#contributors' do
    let!(:entry) { create(:entry) }
    let!(:contributor_a) { create(:user, email: 'a@dabbler.fyi') }
    let!(:contributor_b) { create(:user, email: 'b@dabbler.fyi') }
    let!(:contributor_c) { create(:user, email: 'c@dabbler.fyi') }
    let!(:contributor_d) { create(:user, email: 'd@dabbler.fyi') }
    let(:contributors_via_entry_path) { blog_v1_entry_contributors_path(entry_id: entry.id) }

    it 'returns correct contributors for entry' do
      entry.contributors << contributor_a
      entry.contributors << contributor_b
      entry.contributors << contributor_c

      get contributors_via_entry_path, format: :json
      order = [contributor_a.id, contributor_b.id, contributor_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'pages contributors of entries' do
      entry.contributors << contributor_a
      entry.contributors << contributor_b
      entry.contributors << contributor_c
      entry.contributors << contributor_d

      get contributors_via_entry_path, start: 1, count: 2, format: :json
      order = [contributor_b.id, contributor_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end



end
