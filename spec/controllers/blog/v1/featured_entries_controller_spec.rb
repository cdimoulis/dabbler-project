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
      featured_entry = build(:featured_entry)
      post :create, featured_entry: featured_entry.attributes, format: :json
      expect(response).to have_http_status(:success)
      expect(FeaturedEntry.count).to eq(current+1)
    end

  end
  # Tests for INDEX route
  context "#index" do
    let!(:one) { create(:featured_entry, data: {published_at: (DateTime.now - 1.days).strftime}, created_at: (DateTime.now - 10.days).strftime) }
    let!(:two) { create(:featured_entry, data: {published_at: (DateTime.now - 2.days).strftime}, created_at: (DateTime.now - 9.days).strftime) }
    let!(:three) { create(:featured_entry, data: {published_at: (DateTime.now - 3.days).strftime}, created_at: (DateTime.now - 8.days).strftime) }
    let!(:four) { create(:featured_entry, data: {published_at: (DateTime.now - 4.days).strftime}, created_at: (DateTime.now - 7.days).strftime) }
    let!(:five) { create(:featured_entry, data: {published_at: (DateTime.now - 5.days).strftime}, created_at: (DateTime.now - 6.days).strftime) }

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      puts "\n\n#{one.data['published_at']} - #{one.created_at}\n\n"
      expect(response.body).to look_like_json
      order = [one.id, two.id, three.id, four.id, five.id]
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
  end
end
