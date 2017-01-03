require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesController, type: :controller do


  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:published_entry) { create(:published_entry) }

    # Before running a test do this
    before do
      get :show, id: published_entry.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns correct JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      entry = published_entry.entry
      expect(response.body).to look_like_json
      expect(JSON.parse(response.body)["text"]).to eq(entry.text)
    end

    it { expect(assigns(:record)).to eq(published_entry) }
  end


end
