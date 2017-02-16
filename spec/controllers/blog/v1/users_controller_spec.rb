require 'rails_helper'

RSpec.describe Blog::V1::UsersController, type: :controller do
  include RequestSpecHelper

  # Tests for CREATE route
  context '#create' do
    it 'succeeds - existing person' do
      current_user = User.count
      current_person = Person.count
      person = create(:person)

      user = attributes_for(:user, person_id: person.id)
      post :create, user: user, format: :json
      expect(response).to have_http_status(:success)
      expect(User.count).to eq(current_user+1)
      expect(Person.count).to eq(current_person+1)
    end

    it 'succeeds - person attributes' do
      current_user = User.count
      current_person = Person.count

      person = attributes_for(:person)
      user = attributes_for(:user, person: person)
      post :create, user: user, format: :json
      expect(response).to have_http_status(:success)
      expect(User.count).to eq(current_user+1)
      expect(Person.count).to eq(current_person+1)
    end

    it 'does not allow duplicate email' do
      create(:user, email: "test1@dabbler.fyi")
      duplicate = {email: 'test1@dabbler.fyi', password: '12345678', password_confirmation: '12345678',}
      post :create, user: duplicate, format: :json
      expect(response).to have_http_status(422)
    end

    it 'does not allow mismatch password confirmation' do
      user = {email: 'test1@dabbler.fyi', password: '12345678', password_confirmation: 'abc',}
      post :create, user: user, format: :json
      expect(response).to have_http_status(422)
    end
  end

  # Tests for INDEX route
  context "#index" do
    let!(:chris) { build(:person, first_name: 'Chris', last_name: 'Dimoulis') }
    let!(:naomi) { build(:person, first_name: 'Naomi', last_name: 'Dimoulis') }
    let!(:c_user) { create(:user, email: "chris@test.com", person: chris) }
    let!(:n_user) { create(:user, email: "naomi@test.com", person: naomi) }

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON and sorted by email' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [c_user.id, n_user.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

  end

  # Tests for SHOW route
  context "#show" do

    let!(:chris) { create(:user, email: 'chris@test.com') }

    # Before running a test do this
    before do
      get :show, id: chris.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it { expect(assigns(:record)).to eq(chris) }

  end

  # Test for UPDATE route
  context "#update" do

    let!(:chris) { create(:user, email: 'chris@test.com') }

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {email: "chris@dabbler.fyi"}
      put :update, id: chris.id, user: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).email).to eq(update_params[:email])
    end

    it "prevents invalid updates" do
      create(:user, email: "naomi@test.com")
      update_params = {email: "naomi@test.com"}
      put :update, id: chris.id, user: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for DESTROY route
  context "#destroy" do
    let!(:admin) { create(:user) }
    let!(:chris) { create(:user, email: 'chris@test.com') }
    let!(:current_user) { User.count }
    let!(:current_person) { Person.count }

    before do
      sign_in_as admin
      delete :destroy, id: chris.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(User.count).to eq(current_user-1)
      # Checking dependent destroy
      expect(Person.count).to eq(current_person-1)
    end
  end
end
