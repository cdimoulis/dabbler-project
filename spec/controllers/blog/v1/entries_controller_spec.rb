require 'rails_helper'

RSpec.describe Blog::V1::EntriesController do

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
      current = Entry.count
      entry = build(:entry)
      post :create, entry: entry.attributes, format: :json
      expect(response).to have_http_status(:success)
      expect(Entry.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do

    let!(:third) { create(:entry_with_creator, text: 'Third Entry') }
    let!(:second) { create(:entry_with_creator, text: 'Second Entry') }
    let!(:first) { create(:entry_with_creator, text: 'First Entry') }

    it 'returns JSON and sorted by text' do
      get :index, format: :json
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response).to have_http_status(:success)
      expect(response.body).to look_like_json
      order = [first.id, second.id, third.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'handles date range' do
      third.created_at = 10.days.ago
      third.save
      second.created_at = 5.days.ago
      second.save

      get :index, from: 6.days.ago, format: :json
      expect(assigns(:records).length).to eq(2)
      expect(assigns(:records).include?(third)).to be_falsy
    end

  end

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:entry) { create(:entry) }

    # Before running a test do this
    before do
      get :show, id: entry.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it { expect(assigns(:record)).to eq(entry) }
  end

  # Test for UPDATE route
  context "#update" do
    before do
      sign_in
    end

    # Allow travel to be shared across all tests
    let!(:entry) { create(:entry) }

    it "succeeds" do
      update_params = {description: "Some new information"}
      put :update, id: code.id, domain: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end
  end
end
