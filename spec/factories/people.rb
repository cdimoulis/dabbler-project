# == Schema Information
#
# Table name: people
#
#  id                  :uuid             not null, primary key
#  prefix              :string
#  first_name          :string
#  middle_name         :string
#  last_name           :string
#  suffix              :string
#  gender              :string
#  birth_date          :date
#  phone               :string
#  address_one         :string
#  address_two         :string
#  city                :string
#  state_region        :string
#  country             :string
#  postal_code         :string
#  facebook_id         :string
#  facebook_link       :string
#  twitter_id          :string
#  twitter_screen_name :string
#  instagram_id        :string
#  instagram_username  :string
#  creator_id          :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Factory for
#   Person model
FactoryGirl.define do

  factory :person do
    prefix "Mr."
    first_name "First"
    middle_name "Middle"
    last_name "Last"
    suffix "Jr."
    gender "Male"
    birth_date { 30.years.ago.to_date }
    phone "123-456-78-9012"
    address_one "123 Street Rd."
    city "Chicago"
    state_region "Illinois"
    country "United States"
    postal_code "60061"
    # creator_id => Add when admin association is ready
    # created_at { DateTime.now.to_date.to_time }
    # updated_at { DateTime.now.to_date.to_time }

  end
end
