require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesTopicsController, type: :controller do

  # test for CREATE route
  context '#create' do
    let!(:current_user) { sign_in }
    # Need to act like the application controller set the current_user
    # Clearance sign_in does not call controller hooks
    before do
      Thread.current[:user] = current_user
    end
    it 'errors - no data' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'succeeds' do
      current = PublishedEntriesTopic.count
      published_entries_topic = attributes_for(:published_entries_topic)
      post :create, published_entries_topic: published_entries_topic, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).creator_id).to eq(current_user.id)
      expect(PublishedEntriesTopic.count).to eq(current+1)
    end

    it 'errors - incomplete data' do
      published_entries_topic = attributes_for(:published_entries_topic, topic_id: nil)
      post :create, published_entries_topic: published_entries_topic, format: :json
      expect(response).to have_http_status(422)
      published_entries_topic = attributes_for(:published_entries_topic, published_entry_id: nil)
      post :create, published_entries_topic: published_entries_topic, format: :json
      expect(response).to have_http_status(422)
    end
  end

  # test for INDEX route
  context '#index' do
    let!(:one) {create(:published_entries_topic)}
    let!(:two) {create(:published_entries_topic)}
    let!(:three) {create(:published_entries_topic)}

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [one.id, two.id, three.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end
  end

  # Tests for SHOW route
  context "#show" do
    let!(:published_entries_topics) { create(:published_entries_topic) }

    # Before running a test do this
    before do
      get :show, id: published_entries_topics.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it { expect(assigns(:record)).to eq(published_entries_topics) }
  end

end
