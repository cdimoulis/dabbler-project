# == Schema Information
#
# Table name: domain_groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DomainGroup < ApplicationRecord

  belongs_to :domain

  validates :text, :domain_id, presence: true
  validates :text, uniqueness: {scope: :domain_id, message: "Domain text must be unique"}
  validate :domain_exists


  private

    def domain_exists
      if attribute_present?(:domain_id) and !Domain.exists?(domain_id)
        errors.add(:domain_id, "Invalid Domain")
        return false
      end

      true
    end

end
