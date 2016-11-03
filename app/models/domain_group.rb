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

  def domain
    if @domain.nil? and !self.domain_id.nil? and Domain.exists?(self.domain_id)
      @domain = Domain.find self.domain_id
    end
    @domain
  end

  def domain=(new_domain)
    if !new_domain.nil? and !new_domain.id.nil?
      self.domain_id = new_domain.id
    end
  end

  private

    def domain_exists
      if attribute_present?(:domain_id) and !Domain.exists?(domain_id)
        errors.add(:domain_id, "Invalid Domain")
        return false
      end

      return true
    end

end
