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
#  person_id              :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Admin < ApplicationRecord
  include AssociationAccessors

  devise :database_authenticatable, :registerable, :recoverable,
         :trackable, :validatable, :lockable, :timeoutable

  belongs_to :person, dependent: :destroy

  before_create :create_person


  protected

    # For AssociatioAccessors concern
    def association_params
      {:person => Person.column_names - ['creator_id']}
    end

    def create_person
      # Either there will be a person or person attributes from controller will exist
      raise "Admin Create Error: no person model or attributes to create" if self.person.nil?

      if self.person.id.nil?
        person = Person.new(self.person)
        # If there is a current admin then add as creator
        if !current_admin.nil?
          person.creator_id = current_admin.id?
        end

        if person.valid? and person.save
          @person = person
          self.person_id = person.id
        else
          puts "Admin Create Error: Could not create person model #{person.errors.inspect}"
          Rails.logger.info "Admin Create Error: Could not create person model #{person.errors.inspect}"
          return false
        end
      else
        @person = Person.find(person.id)
        self.person_id = person.id
      end

    end

end
