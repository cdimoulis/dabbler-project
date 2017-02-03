require 'rails_helper'

RSpec.describe Blog::V1::TutorialEntriesController, type: :controller do

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
      current = TutorialEntry.count
      tutorial_entry = attributes_for(:tutorial_entry)
      post :create, tutorial_entry: tutorial_entry, format: :json
      expect(response).to have_http_status(:success)
      expect(TutorialEntry.count).to eq(current+1)
    end

    it 'succeeds with group_topic_published_entries' do
      count = GroupTopicPublishedEntry.count
      tutorial_entry = attributes_for(:tutorial_entry)
      group = create(:tutorial_group, domain: tutorial_entry[:domain])
      gtpe_a = attributes_for(:group_topic_published_entry, group: group, domain: tutorial_entry[:domain], published_entry: nil)
      gtpe_b = attributes_for(:group_topic_published_entry, group: group, domain: tutorial_entry[:domain], published_entry: nil)
      tutorial_entry[:group_topic_published_entries_attributes] = [gtpe_a, gtpe_b]
      post :create, tutorial_entry: tutorial_entry, format: :json
      expect(response).to have_http_status(:success)
      expect(GroupTopicPublishedEntry.count).to eq(count+2)
      expect(GroupTopicPublishedEntry.first.published_entry_id).to eq(TutorialEntry.first.id)
    end
  end

  # Tests for INDEX route
  context "#index" do
    let!(:five) { create(:tutorial_entry, data: {order: 5}, created_at: (DateTime.now - 6.days).strftime) }
    let!(:four) { create(:tutorial_entry, data: {order: 4}, created_at: (DateTime.now - 7.days).strftime) }
    let!(:three) { create(:tutorial_entry, data: {order: 3}, created_at: (DateTime.now - 8.days).strftime) }
    let!(:two) { create(:tutorial_entry, data: {order: 2}, created_at: (DateTime.now - 9.days).strftime) }
    let!(:one) { create(:tutorial_entry, data: {order: 1}, created_at: (DateTime.now - 10.days).strftime) }

    it 'returns correct records' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [one.id, two.id, three.id, four.id, five.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'pages records' do
      # count only
      get :index, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [one.id, two.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # start only
      get :index, start: 2, format: :json
      expect(assigns(:records).length).to eq(3)
      order = [three.id, four.id, five.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # count andd start
      get :index, start: 1, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [two.id, three.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

  end

  # Tests for SHOW route
  context "#show" do

    let!(:tutorial_entry) { create(:tutorial_entry) }

    # Before running a test do this
    before do
      get :show, id: tutorial_entry.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns correct JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it 'includes association attributes' do
      entry = tutorial_entry.entry
      expect(JSON.parse(response.body)["text"]).to eq(entry.text)
    end

    it { expect(assigns(:record)).to eq(tutorial_entry) }
  end

  # Test for UPDATE route
  context "#update" do
    before do
      sign_in
    end


    let!(:tutorial_entry) { create(:tutorial_entry, data: {order: 1}) }

    it "succeeds" do
      tut_entry = create(:tutorial_entry, data: {order: 2})
      group = create(:tutorial_group, domain: tutorial_entry.domain)
      # To ensure the join model does not dissapear on update
      gtpe_a = create(:group_topic_published_entry, domain: tutorial_entry.domain, group: group, published_entry: tutorial_entry)
      count = GroupTopicPublishedEntry.count

      update_params = {data: {order: 3}}
      put :update, id: tutorial_entry.id, tutorial_entry: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).data['published_at']).to eq(update_params[:data][:published_at])
      expect(GroupTopicPublishedEntry.count).to eq(count)

      get :index, format: :json
      order = [tut_entry.id, tutorial_entry.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'updates group_topic_published_entries' do
      group = create(:tutorial_group, domain: tutorial_entry.domain)
      gtpe_a = attributes_for(:group_topic_published_entry, domain: tutorial_entry.domain, group: group, published_entry: nil)
      gtpe_b = attributes_for(:group_topic_published_entry, domain: tutorial_entry.domain, group: group, published_entry: nil)

      gtpe_c = attributes_for(:group_topic_published_entry, domain: tutorial_entry.domain, group: group, published_entry: nil)
      gtpe_d = attributes_for(:group_topic_published_entry, domain: tutorial_entry.domain, group: group, published_entry: nil)

      # First set
      update_params = {group_topic_published_entries_attributes: [gtpe_a, gtpe_b]}
      current = GroupTopicPublishedEntry.count
      put :update, id: tutorial_entry.id, tutorial_entry: update_params, format: :json
      expect(tutorial_entry.group_topic_published_entries.pluck('id')).to match(GroupTopicPublishedEntry.pluck('id'))
      expect(GroupTopicPublishedEntry.count).to eq(2)

      # Second set
      update_params = {group_topic_published_entries_attributes: [gtpe_a, gtpe_b]}
      current = GroupTopicPublishedEntry.count
      put :update, id: tutorial_entry.id, tutorial_entry: update_params, format: :json
      expect(tutorial_entry.group_topic_published_entries.pluck('id')).to match(GroupTopicPublishedEntry.pluck('id'))
      expect(GroupTopicPublishedEntry.count).to eq(2)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:tutorial_entry) { create(:tutorial_entry) }

    before do
      sign_in
      tutorial_entry.groups << create(:tutorial_group, domain: tutorial_entry.domain)
    end

    it "succeeds" do
      count = TutorialEntry.count
      join_count = GroupTopicPublishedEntry.count
      delete :destroy, id: tutorial_entry.id, format: :json
      expect(response).to have_http_status(:success)
      expect(TutorialEntry.count).to eq(count-1)
      expect(GroupTopicPublishedEntry.count).to eq(join_count-1)
    end
  end
end
