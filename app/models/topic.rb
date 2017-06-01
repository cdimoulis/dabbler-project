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

  default_scope { order(text: :asc) }

  belongs_to :domain
  belongs_to :menu_group
  belongs_to :creator, class_name: "User"
  has_many :menu_group_published_entry_topics
  has_many :published_entries, through: :menu_group_published_entry_topics
  has_many :featured_entries, through: :menu_group_published_entry_topics

  before_validation :set_domain_id, if: "domain_id.nil?"

  validates :text, :domain_id, :group_id, :creator_id, presence: true
  validates :text, uniqueness: {scope: :group_id, message: "Topic text must be unique within Group"}
  validate :domain_exists, :menu_group_exists, :domain_is_correct

  protected

  def domain_exists
    if attribute_present?(:domain_id) and !Domain.exists?(domain_id)
      errors.add(:domain_id, "Topic Model: Invalid Domain: Does not exist")
    end
  end

  def menu_group_exists
    if attribute_present?(:menu_group_id) and !MenuGroup.exists?(menu_group_id)
      errors.add(:menu_group_id, "Topic Model: Invalid MenuGroup: Does not exist")
    end
  end

  # Given domain is same as group domain
  def domain_is_correct
    if attribute_present?(:menu_group_id) and attribute_present?(:domain_id)
      menu_group = MenuGroup.where('id = ?', menu_group_id).take
      if menu_group.present?
        if menu_group.domain_id != domain_id
          errors.add(:domain_id, "Topic Model: Topic domain does not match menu_group domain")
        end
      end
    end
  end

  def set_domain_id
    if !menu_group.nil?
      self.domain_id = menu_group.domain_id
    end
  end

end
