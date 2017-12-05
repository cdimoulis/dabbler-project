require 'rails_helper'

RSpec.describe Blog::V1::PublishedEntriesTopicsController, type: :controller do

  let!(:current_user) { sign_in }
  # Need to act like the application controller set the current_user
  # Clearance sign_in does not call controller hooks
  before do
    Thread.current[:user] = current_user
  end

  # test for CREATE route
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

end
