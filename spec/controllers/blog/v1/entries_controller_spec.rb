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
      entry = attributes_for(:entry)
      post :create, entry: entry, format: :json
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
      expect(assigns(:records).to_a).to match([first,second,third,fourth])
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
      expect(assigns(:records).to_a).to match([first,second])

      # To only
      get :index, to: 6.days.ago, format: :json
      expect(assigns(:records).length).to eq(2)
      expect(assigns(:records).to_a).to match([third,fourth])

      # To and from
      get :index, from: 12.days.ago, to: 3.days.ago, format: :json
      expect(assigns(:records).length).to eq(2)
      expect(assigns(:records).to_a).to match([second,third])
    end

    it 'pages records' do
      # count only
      get :index, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      expect(assigns(:records).to_a).to match([first,second])

      # start only
      get :index, start: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      expect(assigns(:records).to_a).to match([third,fourth])

      # count andd start
      get :index, start: 1, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      expect(assigns(:records).to_a).to match([second,third])
    end

    it 'shows unpublished' do
      create(:published_entry, entry: first)
      create(:published_entry, entry: third)
      get :index, unpublished: true, format: :json
      expect(assigns(:records).to_a).to match([second,fourth])
    end

  end

  # Tests for SHOW route
  context "#show" do

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

    it "does not update an already updated entry" do
      update_entry = create(:entry_with_creator)
      entry.locked = true
      entry.updated_entry = update_entry
      entry.save
      update_params = {description: "Some new information"}
      put :update, id: entry.id, entry: update_params
      expect(response).to have_http_status(422)
    end

    it 'changes published_entry associations' do
      pe1 = create(:published_entry, entry: entry, created_at: (DateTime.now - 1.days).strftime)
      pe2 = create(:published_entry, entry: entry, created_at: (DateTime.now - 2.days).strftime)
      pe3 = create(:published_entry, entry: entry, created_at: (DateTime.now - 3.days).strftime)
      pe4 = create(:published_entry, created_at: (DateTime.now - 4.days).strftime)
      update_params = {description: "Some new information"}
      put :update, id: entry.id, entry: update_params
      entry.reload
      expect(entry.locked).to be_truthy
      expect(assigns(:record).id).not_to eq(entry.id)
      expect(entry.published_entries.empty?).to be_truthy
      expect(assigns(:record).published_entries).to match([pe1,pe2,pe3])
    end
  end

  # Test for DESTROY route
  context "#destroy" do

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
      entry.update_attribute('locked', true)
      delete :destroy, id: entry.id, format: :json
      expect(response).to have_http_status(422)
    end

    it "succeeds" do
      current = Entry.count
      entry.update_attribute('locked', true)
      entry.update_attribute('remove', true)
      delete :destroy, id: entry.id, format: :json
      expect(response).to have_http_status(:success)
      expect(Entry.count).to eq(current-1)
    end

    it 'removes published entries' do
      published_entry = create(:published_entry, entry: entry)
      entry.update_attribute('remove', true)
      count = Entry.count
      pe_count = PublishedEntry.count
      delete :destroy, id: entry.id, format: :json
      expect(response).to have_http_status(:success)
      expect(Entry.count).to eq(count-1)
      expect(PublishedEntry.count).to eq(pe_count-1)
    end
  end
end
