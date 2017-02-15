require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesController, type: :controller do

  # Tests for INDEX route
  context "#index" do
    let!(:one) {create(:published_entry)}
    let!(:two) {create(:published_entry)}

    it 'returns JSON' do
      get :index, format: :json
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response).to have_http_status(:success)
      expect(response.body).to look_like_json
      order = [one, two]
      expect(assigns(:records).to_a).to match(order)
    end

    it 'ignores removed' do
      three = create(:published_entry, removed: true)
      get :index, format: :json
      order = [one, two]
      expect(assigns(:records).to_a).to match(order)
    end

    it 'shows removed' do
      two.update_attribute('removed', true)
      three = create(:published_entry, removed: true)
      get :index, removed: true, format: :json
      order = [two, three]
      expect(assigns(:records).to_a).to match(order)
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
