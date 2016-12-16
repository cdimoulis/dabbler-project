require 'rails_helper'

RSpec.describe Blog::V1::EntriesController do
  include RequestSpecHelper

  context '#contributors' do
    let!(:entry) { create(:entry_with_creator) }
    let(:contributors_via_entry_path) { blog_v1_entry_contributors_path(entry_id: entry.id) }

    it 'returns correct entries for author' do
      contributor_a = create(:user, email: 'a@dabbler.fyi')
      contributor_b = create(:user, email: 'b@dabbler.fyi')
      contributor_c = create(:user, email: 'c@dabbler.fyi')
      contributor_d = create(:user, email: 'd@dabbler.fyi')

      entry.contributors << contributor_a
      entry.contributors << contributor_b
      entry.contributors << contributor_c

      get contributors_via_entry_path, format: :json
      order = [contributor_a.id, contributor_b.id, contributor_c.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

end
