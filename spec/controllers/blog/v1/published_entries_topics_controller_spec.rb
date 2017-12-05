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

  # Tests for UPDATE route
  context '#update' do
    let!(:published_entries_topic) { create(:published_entries_topic) }

    before do
      sign_in
    end

    it 'succeeds' do
      update_params = {order: 1}
      put :update, id: published_entries_topic.id, published_entries_topic: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).order).to eq(1)
    end

    it 'succeeds - topic' do
      topic = create(:topic_with_domain, domain: published_entries_topic.published_entry.domain)
      update_params = {topic_id: topic.id}
      put :update, id: published_entries_topic.id, published_entries_topic: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).topic_id).to eq(topic.id)
    end

    it 'succeeds - topic' do
      published_entry = create(:published_entry, domain_id: published_entries_topic.topic.domain.id)
      update_params = {published_entry_id: published_entry.id}
      put :update, id: published_entries_topic.id, published_entries_topic: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).published_entry_id).to eq(published_entry.id)
    end

    it 'errors - invalid order' do
      pet1 = create(:published_entries_topic_with_domain, topic: published_entries_topic.topic, domain: published_entries_topic.published_entry.domain, order: 1)
      pet2 = create(:published_entries_topic_with_domain, topic: published_entries_topic.topic, domain: published_entries_topic.published_entry.domain, order: 2)
      update_params = {order: 2}
      put :update, id: published_entries_topic.id, published_entries_topic: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

end
