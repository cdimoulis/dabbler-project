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

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
