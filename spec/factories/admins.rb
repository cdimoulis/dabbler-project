# == Schema Information
#
# Table name: admins
#
#  id                     :uuid             not null, primary key
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  person_id              :uuid
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryGirl.define do

  factory :admin do
    email 'admin_test@dabbler.fyi'
    password '12345678'
    person { create(:person, first_name: "Admin", last_name: "Test") }

    created_at { DateTime.now.to_date.to_time }
    updated_at { DateTime.now.to_date.to_time }

    factory :admin_without_person do
      person nil
    end

  end
end
