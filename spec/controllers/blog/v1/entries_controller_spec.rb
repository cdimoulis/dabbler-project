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
    let!(:fourth) { create(:entry_with_creator, text: '4th Entry') }
    let!(:third) { create(:entry_with_creator, text: '3rd Entry') }
    let!(:second) { create(:entry_with_creator, text: '2nd Entry') }
    let!(:first) { create(:entry_with_creator, text: '1st Entry') }

    it 'returns JSON and sorted by text' do
      get :index, format: :json
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response).to have_http_status(:success)
      expect(response.body).to look_like_json
      order = [first.id, second.id, third.id, fourth.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'handles date range' do
      fourth.created_at = 15.days.ago
      fourth.save
      third.created_at = 10.days.ago
      third.save
      second.created_at = 5.days.ago
      second.save

      # From only
      get :index, from: 6.days.ago, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [first.id, second.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # To only
      get :index, to: 6.days.ago, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [third.id, fourth.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # To and from
      get :index, from: 12.days.ago, to: 3.days.ago, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [second.id, third.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it 'pages records' do
      # count only
      get :index, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [first.id, second.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # start only
      get :index, start: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [third.id, fourth.id]
      expect(assigns(:records).pluck('id')).to match(order)

      # count andd start
      get :index, start: 1, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [second.id, third.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

  end

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:entry) { create(:entry_with_creator) }

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
    let!(:entry) { create(:entry_with_creator) }

    it "succeeds" do
      update_params = {description: "Some new information"}
      put :update, id: entry.id, entry: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
    end

    it "creates new when locked" do
      entry.locked = true
      entry.save
      update_params = {description: "Some new information"}
      put :update, id: entry.id, entry: update_params, format: :json
      entry.reload
      expect(response).to have_http_status(:success)
      expect(assigns(:record).description).to eq(update_params[:description])
      expect(assigns(:record).text).to eq(entry.text)
      expect(entry.updated_entry_id).to eq(assigns(:record).id)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    # Allow travel to be shared across all tests
    let!(:admin) { create(:user) }
    let!(:entry) { create(:entry_with_creator) }

    before do
      sign_in_as admin
    end

    it "succeeds if not locked" do
      delete :destroy, id: entry.id, format: :json
      expect(response).to have_http_status(:success)
    end

    it "prevents without remove flag" do
      entry.locked = true
      entry.save
      delete :destroy, id: entry.id, format: :json
      expect(response).to have_http_status(422)
    end

    it "succeeds" do
      current = Entry.count
      entry.locked = true
      entry.remove = true
      entry.save
      delete :destroy, id: entry.id, format: :json
      expect(response).to have_http_status(:success)
      expect(Entry.count).to eq(current-1)
    end
  end
end
