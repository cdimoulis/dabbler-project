require 'rails_helper'

RSpec.describe Blog::V1::UsersController do
  include RequestSpecHelper

  context '#entries' do
    let!(:author) { create(:user) }
    let!(:entry_a) { create(:entry, text: "Entry A", author: author, creator: author) }
    let!(:entry_b) { create(:entry, text: "Entry B", author: author, creator: author) }
    let!(:entry_c) { create(:entry, text: "Entry C", author: author, creator: author) }
    let!(:entry_d) { create(:entry, text: "Entry D") }
    let(:entries_via_user_path) { blog_v1_user_entries_path(user_id: author.id) }

    it 'returns correct entries for author' do
      get entries_via_user_path, format: :json
      expect(assigns(:records).length).to eq(3)
      order = [entry_a.id, entry_b.id, entry_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

  context '#contributions' do
    let!(:author) { create(:user) }
    let!(:entry_a) { create(:entry, text: "Entry A") }
    let!(:entry_b) { create(:entry, text: "Entry B") }
    let!(:entry_c) { create(:entry, text: "Entry C") }
    let!(:entry_d) { create(:entry, text: "Entry D") }
    let(:contributions_via_user_path) { blog_v1_user_contributions_path(user_id: author.id) }

    it 'returns correct entries for author' do
      entry_b.contributors << author
      entry_c.contributors << author
      entry_d.contributors << author

      get contributions_via_user_path, format: :json
      expect(assigns(:records).length).to eq(3)
      order = [entry_b.id, entry_c.id, entry_d.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

end
