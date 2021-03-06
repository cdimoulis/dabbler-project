# == Schema Information
#
# Table name: users
#
#  id                 :uuid             not null, primary key
#  email              :string           not null
#  encrypted_password :string(128)      not null
#  confirmation_token :string(128)
#  remember_token     :string(128)      not null
#  locked_at          :datetime
#  last_sign_in_ip    :inet
#  last_sign_in_at    :datetime
#  user_type          :string
#  person_id          :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do

  factory :user do
    email { "user_test#{User.count}@dabbler.fyi" }
    password '12345678'
    password_confirmation '12345678'
    person { create(:person, first_name: "User", last_name: "Test") }
    person_id { person.present? ? person.id : nil }

    factory :user_as_admin do
      user_type "Admin"
    end

    factory :user_without_person do
      person nil
      person_id nil
    end

  end
end
