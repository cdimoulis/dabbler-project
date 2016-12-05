require 'rails_helper'

RSpec.describe User do
  include RequestSpecHelper

  context '#create while signed in' do
    let!(:admin) { create(:user) }

    before do
      full_sign_in admin, '12345678'
    end

    after do
      full_sign_out
    end

    it 'succeeds' do
      person = {prefix: "Mr.", first_name: "Chris", last_name: "Dimoulis", gender: "Male"}
      user = {email: 'user_test@dabbler.com', password: '12345678', password_confirmation: '12345678', person: person}
      post blog_v1_users_path, user: user, format: :json
      expect(admin.id).to eq(assigns(:record).person.creator_id)
    end

  end
end
