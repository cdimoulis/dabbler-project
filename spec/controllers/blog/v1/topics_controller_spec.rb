require 'rails_helper'

RSpec.describe Blog::V1::TopicsController, type: :controller do

  # tests for CREATE route
  context "#create" do
    before do
      sign_in
    end

    it 'errors - no data' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'succeeds' do
      current = Topic.count
      topic = attributes_for(:topic)
      post :create, topic: topic, format: :json
      expect(response).to have_http_status(:success)
      expect(Topic.count).to eq(current+1)
    end
  end

  context "#index" do
    let!(:one) {create(:topic, text: 'A Topic')}
    let!(:two) {create(:topic, text: 'B Topic')}

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

    let!(:topic) { create(:topic) }

    # Before running a test do this
    before do
      get :show, id: topic.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it { expect(assigns(:record)).to eq(topic) }
  end

  # Test for UPDATE route
  context "#update" do

    let!(:group) { create(:group) }
    let!(:topic_a) { create(:topic_without_domain, text: 'Topic A', group: group) }

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {description: "Important topic"}
      put :update, id: topic_a.id, topic: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "prevents invalid updates" do
      topic_b = create(:topic, text: 'Topic A')
      update_params = {group_id: group.id, domain_id: group.domain_id}
      put :update, id: topic_b.id, topic: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:topic) { create(:topic) }
    let!(:current) { Topic.count }

    before do
      sign_in
      delete :destroy, id: topic.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(Topic.count).to eq(current-1)
    end
  end

end
