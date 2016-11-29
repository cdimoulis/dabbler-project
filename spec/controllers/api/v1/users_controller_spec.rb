require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  context '#create' do
    it 'succeeds - existing person' do
      current_user = User.count
      current_person = Person.count
      person = create(:person)
      # Cannot use factory build user. Converts password to encrypted_password
      user = {email: 'user_test@dabbler.com', password: '12345678', person_id: person.id}
      post :create, user: user, format: :json
      expect(response).to have_http_status(:success)
      expect(User.count).to eq(current_user+1)
      expect(Person.count).to eq(current_person+1)
    end

    it 'succeeds - person attributes' do
      current_user = User.count
      current_person = Person.count
      # Cannot use factory build user. Converts password to encrypted_password
      person = {prefix: "Mr.", first_name: "Chris", last_name: "Dimoulis", gender: "Male"}
      user = {email: 'user_test@dabbler.com', password: '12345678', person: person}
      post :create, user: user, format: :json
      expect(response).to have_http_status(:success)
      expect(User.count).to eq(current_user+1)
      expect(Person.count).to eq(current_person+1)
    end
  end
end
