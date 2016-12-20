# == Schema Information
#
# Table name: topics
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  group_id    :uuid             not null
#  creator_id  :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Topic < ApplicationRecord

  belongs_to :domain
  belongs_to :group
  belongs_to :creator, class_name: "User"

  before_validation :set_domain_id, if: "domain_id.nil?"

  validates :text, :domain_id, :group_id, :creator_id, presence: true
  validates :text, uniqueness: {scope: :group_id, message: "Topic text must be unique within Group"}
  validate :domain_exists, :group_exists, :domain_is_correct

  protected

  def domain_exists
    if attribute_present?(:domain_id) and !Domain.exists?(domain_id)
      errors.add(:domain_id, "Invalid Domain: Does not exist")
    end
  end

  def group_exists
    if attribute_present?(:group_id) and !Group.exists?(group_id)
      errors.add(:group_id, "Invalid Group: Does not exist")
    end
  end

  # Given domain is same as group domain
  def domain_is_correct
    if !group.nil? and attribute_present?(:domain_id)
      if !(group.domain_id == domain_id)
        errors.add(:domain_id, "Topic domain does not match group domain")
      end
    end
  end

  def set_domain_id
    if !group.nil?
      self.domain_id = group.domain_id
    end
  end

end
