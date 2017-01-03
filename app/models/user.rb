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

  attr_accessor :password_confirmation

  belongs_to :person, dependent: :destroy
  has_many :entries, foreign_key: :author_id
  has_and_belongs_to_many :contributions, class_name: 'Entry'

  before_create :create_person
  after_create :send_new_user_email

  validates :user_type, inclusion: { in: TYPE_OPTIONS }, allow_blank: true
  validate :password_match, on: :create


  def password_confirmation=(val)
    # Needed to accept in controller
    @password_confirmation = val
  end


  def is_admin?
    user_type == ADMIN_TYPE
  end

  # Be able to access the current user in models
  def self.current
    if Thread.current.key?(:user)
      current = Thread.current[:user]
    end
    current
  end

  # To send association attributes
  # def attributes
  #   super.merge(:first_name => self.first_name, :middle_name => self.middle_name,
  #     :last_name => self.last_name, :suffix => self.suffix, :prefix => self.prefix,
  #     :gender => self.gender, :birth_date => self.birth_date, :phone => self.phone)
  # end

  ###
  # For AssociationAccessors concern
  ###
  def association_attributes
    {:person => Person.column_names}
  end

  def send_attributes
    Person.column_names
  end
  ###
  # End AssociationAccessorconcern
  ###

  protected

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

      if !User.current.nil?
        person.creator_id = User.current.id
      end

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

  def password_match
    if  !(BCrypt::Password.new(self.encrypted_password) == self.password_confirmation)
      errors.add :password, "Password and Password Confirmation do not match"
    end
  end

  def send_new_user_email
    # if ENV['ENABLE_RESET_USER_PASSWORD'].to_i > 0
      # generate_confirmation_token
      # save
      # mail = UserMailer.change_password(self)
      # mail.deliver_later
    # end
    generate_confirmation_token
    save
    mail = UserMailer.create_user(self)

    if mail.respond_to?(:deliver_later)
      mail.deliver_later
    else
      mail.deliver
    end
  end

end
