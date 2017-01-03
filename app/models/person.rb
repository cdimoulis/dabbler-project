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

class Person < ApplicationRecord
  include PersonLists
  include Addresses
  include AssociationAccessors

  default_scope { order(last_name: :asc, first_name: :asc) }

  has_one :user
  belongs_to :creator, class_name: "User"

  validates :gender, inclusion: { in: GENDERS }, allow_blank: true
  validates :prefix, inclusion: { in: PREFIXES }, allow_blank: true
  validates :suffix, inclusion: { in: SUFFIXES }, allow_blank: true
  validate :countryExists, :stateExists

  protected

  # For AssociationAccessors concern
  def association_params
    {:user => [:email]}
  end

end
