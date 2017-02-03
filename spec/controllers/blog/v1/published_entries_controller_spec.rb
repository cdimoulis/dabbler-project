require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesController, type: :controller do

  # Tests for INDEX route
  context "#index" do
    let!(:one) {create(:published_entry)}
    let!(:two) {create(:published_entry)}

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [one.id, two.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

  end

  # Tests for SHOW route
  context "#show" do
    
    let!(:published_entry) { create(:published_entry) }

    # Before running a test do this
    before do
      get :show, id: published_entry.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns correct JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it 'includes association attributes' do
      entry = published_entry.entry
      expect(JSON.parse(response.body)["text"]).to eq(entry.text)
    end

    it { expect(assigns(:record)).to eq(published_entry) }
  end


end
