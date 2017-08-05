require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesController, type: :controller do

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
      current = PublishedEntry.count
      published_entry = attributes_for(:published_entry)
      post :create, published_entry: published_entry, format: :json
      expect(response).to have_http_status(:success)
      expect(PublishedEntry.count).to eq(current+1)
    end
  end

  # Tests for INDEX route
  context "#index" do
    let!(:one) { create(:published_entry, published_at: (DateTime.now.end_of_day - 1.days).strftime, created_at: (DateTime.now.end_of_day - 8.days).strftime) }
    let!(:two) { create(:published_entry, published_at: (DateTime.now.end_of_day - 2.days).strftime, created_at: (DateTime.now.end_of_day - 7.days).strftime) }
    let!(:three) { create(:published_entry, published_at: (DateTime.now.end_of_day - 3.days).strftime, created_at: (DateTime.now.end_of_day - 6.days).strftime) }
    let!(:four) { create(:published_entry, published_at: (DateTime.now.end_of_day - 4.days).strftime, created_at: (DateTime.now.end_of_day - 5.days).strftime) }
    let!(:five) { create(:published_entry, published_at: (DateTime.now.end_of_day - 5.days).strftime, created_at: (DateTime.now.end_of_day - 4.days).strftime) }
    let!(:six) { create(:published_entry, published_at: (DateTime.now.end_of_day - 6.days).strftime, created_at: (DateTime.now.end_of_day - 3.days).strftime) }

    it 'returns correct records' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [one, two, three, four, five, six]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end

    it 'ignores removed' do
      three.update_attribute('removed', true)
      five.update_attribute('removed', true)
      get :index, format: :json
      order = [one, two, four, six]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end

    it 'shows removed' do
      two.update_attribute('removed', true)
      four.update_attribute('removed', true)
      get :index, removed: true, format: :json
      order = [two, four]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end

    it 'shows current' do
      two.update_attribute('revised_published_entry_id', one.id)
      four.update_attribute('revised_published_entry_id', three.id)
      get :index, current: true, format: :json
      order = [one, three, five, six]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end

    it 'shows published' do
      two.update_attribute('published_at', DateTime.now + 2.days)
      four.update_attribute('published_at', DateTime.now + 1.minute)
      get :index, published: true, format: :json
      order = [one, three, five, six]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end

    it 'shows unpublished' do
      two.update_attribute('published_at', DateTime.now + 2.days)
      four.update_attribute('published_at', DateTime.now + 1.minute)
      get :index, not_published: true, format: :json
      order = [two, four]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end

    it 'handles date range' do
      # From only
      get :index, from: 3.days.ago, format: :json
      expect(assigns(:records).length).to eq(3)
      order = [one, two, three]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)

      # To only
      get :index, to: 3.days.ago, format: :json
      expect(assigns(:records).length).to eq(3)
      order = [four, five, six]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)

      # From only
      get :index, from: 4.days.ago, to: 2.days.ago, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [three, four]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end

    it 'pages records' do
      # count only
      get :index, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [one, two]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)

      # start only
      get :index, start: 2, format: :json
      expect(assigns(:records).length).to eq(4)
      order = [three, four, five, six]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)

      # count andd start
      get :index, start: 1, count: 2, format: :json
      expect(assigns(:records).length).to eq(2)
      order = [two, three]
      expect(assigns(:records).order('published_at desc').to_a).to match(order)
    end
  end

  # Tests for SHOW route
  context "#show" do
    let!(:published_entry) { create(:published_entry) }

    # Before running a test do this
    before do
      get :show, id: published_entry.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns correct JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it 'includes association attributes' do
      entry = published_entry.entry
      expect(JSON.parse(response.body)["text"]).to eq(entry.text)
    end

    it { expect(assigns(:record)).to eq(published_entry) }
  end

  # Test for UPDATE route
  context "#update" do
    before do
      sign_in
    end

    let!(:published_entry) { create(:published_entry) }

    it "succeeds" do
      feat_entry = create(:published_entry, published_at: (DateTime.now - 1.days).strftime)

      update_params = {published_at: (DateTime.now - 2.days).strftime}
      put :update, id: published_entry.id, published_entry: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).published_at).to eq(update_params[:published_at])

      get :index, format: :json
      order = [feat_entry.id, published_entry.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:published_entry) { create(:published_entry) }

    before do
      sign_in
    end

    it "succeeds" do
      delete :destroy, id: published_entry.id, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).id).to eq(published_entry.id)
      expect(assigns(:record).removed).to be_truthy
    end
  end
end
