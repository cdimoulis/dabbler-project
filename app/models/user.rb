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

class User < ApplicationRecord
  include Clearance::User
  include AssociationAccessors
  include UserTypes

  default_scope { order(email: :asc) }

  attr_accessor :prefix, :first_name, :middle_name, :last_name, :suffix, :gender,
                :birth_date, :phone, :address_one, :address_two, :city, :state_region,
                :country, :postal_code, :facebook_id, :facebook_link, :twitter_id,
                :twitter_screen_name, :instagram_id, :instagram_username

  belongs_to :person, dependent: :destroy

  before_create :create_person

  validates :user_type, inclusion: { in: TYPE_OPTIONS }, allow_blank: true


  def is_admin?
    user_type == ADMIN_TYPE
  end


  protected

    # For AssociatioAccessors concern
    def association_params
      {:person => Person.column_names - ['creator_id']}
    end

    def create_person
      # If no person_id then create new person
      if self.person_id.nil?
        person = Person.new()

        person.prefix = self.prefix
        person.first_name = self.first_name
        person.middle_name = self.middle_name
        person.last_name = self.last_name
        person.suffix = self.suffix
        person.gender = self.gender
        person.birth_date = self.birth_date
        person.phone = self.phone
        person.address_one = self.address_one
        person.address_two = self.address_two
        person.city = self.city
        person.state_region = self.state_region
        person.country = self.country
        person.postal_code = self.postal_code
        person.facebook_id = self.facebook_id
        person.facebook_link = self.facebook_link
        person.twitter_id = self.twitter_id
        person.twitter_screen_name = self.twitter_screen_name
        person.instagram_id = self.instagram_id
        person.instagram_username = self.instagram_username

        # If there is a current admin then add as creator
        # if !current_user.nil?
        #   person.creator_id = current_admin.id?
        # end

        if person.valid? and person.save
          @person = person
          self.person_id = person.id
        else
          puts "User Create Error: Could not create person model #{person.errors.inspect}"
          Rails.logger.info "User Create Error: Could not create person model #{person.errors.inspect}"
          return false
        end
      else
        @person = Person.find(self.person_id)
      end

    end
end
