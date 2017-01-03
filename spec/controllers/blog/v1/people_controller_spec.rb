require "rails_helper"

RSpec.describe Blog::V1::PeopleController do

  # tests for CREATE route
  context "#create" do
    it 'succeeds' do
      current = Person.count
      person = build(:person)
      post :create, person: person.attributes, format: :json
      expect(response).to have_http_status(:success)
      expect(Person.count).to eq(current+1)
    end

  end

  # Tests for INDEX route
  context "#index" do
    let!(:chris) {create(:person, first_name: 'Chris', last_name: 'Dimoulis')}
    let!(:naomi) {create(:person, first_name: 'Naomi', last_name: 'Dimoulis')}
    let!(:bob_1) {create(:person, first_name: 'Bob', last_name: 'Anderson')}
    let!(:bob_2) {create(:person, first_name: 'Bob', last_name: 'Zim')}

    before do
      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON and sorted by last_name, first_name' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
      order = [bob_1.id, chris.id, naomi.id, bob_2.id]
      expect(assigns(:records).pluck('id')).to match(order)
    end

  end

  # Tests for SHOW route
  context "#show" do
    # Allow travel to be shared across all tests
    let!(:chris) { create(:person_with_user, first_name: 'Chris') }

    # Before running a test do this
    before do
      get :show, id: chris.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'returns JSON' do
      # look_like_json found in support/matchers/json_matchers.rb
      expect(response.body).to look_like_json
    end

    it 'includes association attributes' do
      user = chris.user
      expect(JSON.parse(response.body)["email"]).to eq(user.email)
    end

    it { expect(assigns(:record)).to eq(chris) }

  end

  # Test for UPDATE route
  context "#update" do
    # Allow travel to be shared across all tests
    let!(:chris) {create(:person, first_name: 'Chris', last_name: 'Dimoulis')}

    before do
      sign_in
    end

    it "succeeds" do
      update_params = {suffix: "Esq."}
      put :update, id: chris.id, person: update_params, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:record).suffix).to eq(update_params[:suffix])
    end

    it "prevents invalid updates" do
      update_params = {suffix: "VIII"}
      put :update, id: chris.id, person: update_params, format: :json
      expect(response).to have_http_status(424)
    end
  end

  # Test for UPDATE route
  context "#destroy" do
    # Allow travel to be shared across all tests
    let!(:admin) { create(:user) }
    let!(:chris) { create(:person, first_name: 'Chris', last_name: 'Dimoulis') }
    let!(:current) { Person.count }

    before do
      sign_in_as admin
      delete :destroy, id: chris.id, format: :json
    end

    it "succeeds" do
      expect(response).to have_http_status(:success)
      expect(Person.count).to eq(current-1)
    end
  end
end
