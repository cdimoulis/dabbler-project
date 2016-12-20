# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Group < ApplicationRecord

  default_scope { order(text: :asc) }

  belongs_to :domain
  has_many :topics

  validates :text, :domain_id, :type, presence: true
  validates :text, uniqueness: {scope: [:domain_id, :type], message: "Domain text must be unique"}
  validate :domain_exists


  protected

  def domain_exists
    if attribute_present?(:domain_id) and !Domain.exists?(domain_id)
      errors.add(:domain_id, "Invalid Domain: Does not exist")
    end
  end

end
