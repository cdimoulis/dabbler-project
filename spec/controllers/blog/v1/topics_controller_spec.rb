require 'rails_helper'

RSpec.describe Blog::V1::TopicsController, type: :controller do

  # tests for CREATE route
  context "#create" do
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
      current = Topic.count
      topic = attributes_for(:topic, creator: nil)
      post :create, topic: topic, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).creator_id).to eq(current_user.id)
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
    let!(:menu_group) { create(:menu_group) }
    let!(:topic) { create(:topic, menu_group: menu_group) }

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {description: "Important topic"}
      put :update, id: topic.id, topic: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "updates published_entry_ordering" do
      update_params = {published_entry_ordering: ['created_at:asc']}
      put :update, id: topic.id, topic: update_params, format: :json
      puts "\n\n#{assigns(:record).errors.inspect}\n\n"
      expect(response).to have_http_status(:success)
      expect(assigns(:record).published_entry_ordering).to eq(update_params[:published_entry_ordering])
    end

    it "prevents invalid updates" do
      topic_b = create(:topic, text: topic.text)
      update_params = {menu_group_id: menu_group.id}
      put :update, id: topic_b.id, topic: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:topic_a) { create(:topic) }
    let!(:topic_b) { create(:topic) }
    let!(:current) { Topic.count }

    before do
      sign_in
      delete :destroy, id: topic_a.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(Topic.count).to eq(current-1)
    end
  end

end
