require 'rails_helper'

RSpec.describe Blog::V1::FeaturedEntriesController, type: :controller do

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
      current = FeaturedEntry.count
      featured_entry = attributes_for(:featured_entry)
      post :create, featured_entry: featured_entry, format: :json
      expect(response).to have_http_status(:success)
      expect(FeaturedEntry.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:one) { create(:featured_entry, data: {published_at: (DateTime.now - 1.days).strftime}, created_at: (DateTime.now - 8.days).strftime) }
    let!(:two) { create(:featured_entry, data: {published_at: (DateTime.now - 2.days).strftime}, created_at: (DateTime.now - 7.days).strftime) }
    let!(:three) { create(:featured_entry, data: {published_at: (DateTime.now - 3.days).strftime}, created_at: (DateTime.now - 6.days).strftime) }
    let!(:four) { create(:featured_entry, data: {published_at: (DateTime.now - 4.days).strftime}, created_at: (DateTime.now - 5.days).strftime) }
    let!(:five) { create(:featured_entry, data: {published_at: (DateTime.now - 5.days).strftime}, created_at: (DateTime.now - 4.days).strftime) }

    it 'returns correct records' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [one.id, two.id, three.id, four.id, five.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'handles date range' do
      # From only
      get :index, from: 3.days.ago, format: :json
      # puts "\n\n#{assigns(:records).pluck("data ->> 'published_at'")}\n\n"
      expect(assigns(:records).length).to eq(3)
      order = [one.id, two.id, three.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # To only
      get :index, to: 3.days.ago, format: :json
      # puts "\n\n#{assigns(:records).pluck("data ->> 'published_at'")}\n\n"
      expect(assigns(:records).length).to eq(2)
      order = [four.id, five.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # From only
      get :index, from: 4.days.ago, to: 2.days.ago, format: :json
      # puts "\n\n#{assigns(:records).pluck("data ->> 'published_at'")}\n\n"
      expect(assigns(:records).length).to eq(2)
      order = [three.id, four.id]
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
    # Allow travel to be shared across all tests
    let!(:featured_entry) { create(:featured_entry) }

    # Before running a test do this
    before do
      get :show, id: featured_entry.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns correct JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it 'includes association attributes' do
      entry = featured_entry.entry
      expect(JSON.parse(response.body)["text"]).to eq(entry.text)
    end

    it { expect(assigns(:record)).to eq(featured_entry) }
  end

  # Test for UPDATE route
  context "#update" do
    before do
      sign_in
    end

    # Allow travel to be shared across all tests
    let!(:featured_entry) { create(:featured_entry) }

    it "succeeds" do
      feat_entry = create(:featured_entry, data: {published_at: (DateTime.now - 1.days).strftime})
      update_params = {data: {published_at: (DateTime.now - 2.days).strftime}}
      put :update, id: featured_entry.id, featured_entry: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).data['published_at']).to eq(update_params[:data][:published_at])
      get :index, format: :json
      order = [feat_entry.id, featured_entry.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'updates group_topic_published_entries' do
      gtpe_a = attributes_for(:group_topic_published_entry, domain: featured_entry.domain)
      gtpe_b = attributes_for(:group_topic_published_entry, domain: featured_entry.domain)

      update_params = {group_topic_published_entries: [gtpe_a, gtpe_b]}
      current = GroupTopicPublishedEntry.count
      put :update, id: featured_entry.id, featured_entry: update_params, format: :json
      puts "\n\nfeatured_entry #{featured_entry.topics.count}\n\n"
      expect(featured_entry.group_topic_published_entries.pluck('id')).to match([gtpe_a.id, gtpe_b.id])
      expect(GroupTopicPublishedEntry.count).to eq(current+2)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    # Allow travel to be shared across all tests
    let!(:featured_entry) { create(:featured_entry) }

    before do
      sign_in
      featured_entry.groups << create(:group, domain: featured_entry.domain)
    end

    it "succeeds" do
      count = FeaturedEntry.count
      join_count = GroupTopicPublishedEntry.count
      delete :destroy, id: featured_entry.id, format: :json
      expect(response).to have_http_status(:success)
      expect(FeaturedEntry.count).to eq(count-1)
      expect(GroupTopicPublishedEntry.count).to eq(join_count-1)
    end
  end
end
