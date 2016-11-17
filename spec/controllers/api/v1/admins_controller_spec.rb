require 'rails_helper'

RSpec.describe Api::V1::AdminsController, type: :controller do

  # tests for CREATE route
  context "#create" do
    it 'succeeds - existing person' do
      current_admin = Admin.count
      current_person = Person.count
      # Cannot use factory build admin. Converts password to encrypted_password
      person = create(:person)
      admin = {email: 'admin_test@dabbler.com', password: '12345678', person_id: person.id}
      post :create, admin: admin, format: :json
      expect(response).to have_http_status(:success)
      expect(Admin.count).to eq(current_admin+1)
      expect(Person.count).to eq(current_person+1)
    end

    it 'succeeds - person attributes' do
      current_admin = Admin.count
      current_person = Person.count
      # Cannot use factory build admin. Converts password to encrypted_password
      person = {prefix: "Mr.", first_name: "Chris", last_name: "Dimoulis", gender: "Male"}
      admin = {email: 'admin_test@dabbler.com', password: '12345678', person: person}
      post :create, admin: admin, format: :json
      expect(response).to have_http_status(:success)
      expect(Admin.count).to eq(current_admin+1)
      expect(Person.count).to eq(current_person+1)
    end

    it 'handles duplicate email' do
      create(:admin, email: "test1@dabbler.fyi")
      duplicate = {email: 'test1@dabbler.fyi', password: '12345678'}
      post :create, admin: duplicate, format: :json
      expect(response).to have_http_status(422)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:chris) { build(:person, first_name: 'Chris', last_name: 'Dimoulis') }
    let!(:naomi) { build(:person, first_name: 'Naomi', last_name: 'Dimoulis') }
    let!(:c_admin) { create(:admin, email: "chris@test.com", person: chris) }
    let!(:n_admin) { create(:admin, email: "naomi@test.com", person: naomi) }

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON and sorted by email' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      # body_as_json found in support/helpers.rb
      order = [c_admin.id, n_admin.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

    it { expect(assigns(:records).count).to eq(2) }

  end

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:chris) { create(:admin, email: 'chris@test.com') }

    # Before running a test do this
    before do
      get :show, id: chris.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      # body_as_json found in support/helpers.rb
      expect(assigns(:record).id).to match(chris.id)
    end

    it { expect(assigns(:record)).to eq(chris) }

  end

  # Test for UPDATE route
  context "#update" do
    # Allow travel to be shared across all tests
    let!(:chris) { create(:admin, email: 'chris@test.com') }

    it "succeeds" do
      update_params = {email: "chris@dabbler.fyi"}
      put :update, id: chris.id, admin: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).email).to eq(update_params[:email])
    end

    it "prevents invalid updates" do
      create(:admin, email: "naomi@test.com")
      update_params = {email: "naomi@test.com"}
      put :update, id: chris.id, admin: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for UPDATE route
  context "#destroy" do
    # Allow travel to be shared across all tests
    let!(:chris) { create(:admin, email: 'chris@test.com') }
    let!(:current_admin) { Admin.count }
    let!(:current_person) { Person.count }

    before do
      delete :destroy, id: chris.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(Admin.count).to eq(current_admin-1)
      # Checking dependent destroy
      expect(Person.count).to eq(current_person-1)
    end
  end
end
