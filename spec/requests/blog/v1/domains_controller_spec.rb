require 'rails_helper'

RSpec.describe Blog::V1::DomainsController do
  include RequestSpecHelper

  context '#single_index' do
    let!(:domain) { create(:domain) }
    let!(:published_entry) { create(:published_entry, domain: domain) }

    it 'returns correct domain for published_entry' do
      get blog_v1_published_entry_domain_path(published_entry_id: published_entry.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

  end
end
