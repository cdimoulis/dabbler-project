# == Schema Information
#
# Table name: menu_group_published_entry_topics
#
#  id                 :uuid             not null, primary key
#  menu_group_id      :uuid             not null
#  topic_id           :uuid
#  published_entry_id :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class MenuGroupPublishedEntryTopic < ApplicationRecord

  belongs_to :menu_group
  belongs_to :topic
  belongs_to :published_entry
  belongs_to :featured_entry, foreign_key: 'published_entry_id'

  before_validation :set_menu_group

  validates :menu_group_id, :published_entry, presence: true
  validate :valid_menu_group, :valid_domain


  protected

  def set_menu_group
    # If no menu_group_id and topic is not nil, then set group from topic
    if !attribute_present?(:menu_group_id) and !topic.nil?
      self.menu_group_id = topic.menu_group_id
    end
  end

  def valid_menu_group
    if attribute_present?(:topic_id)
      topic = Topic.where('id = ?', topic_id).take
      if topic.present?
        if topic.menu_group != menu_group
          errors.add(:topic_id, "MenuGroupPublishedEntryTopic Model: topic menu_group does not match menu_group_id")
        end
      end
    end
  end

  def valid_domain
    if attribute_present?(:menu_group_id) and attribute_present?(:published_entry_id)
      menu_group = MenuGroup.where('id = ?', menu_group_id).take
      published_entry = PublishedEntry.where('id = ?', published_entry_id).take
      if menu_group.present? and published_entry.present?
        if menu_group.domain != published_entry.domain
          errors.add(:group_id, "MenuGroupPublishedEntryTopic Model: menu_group domain does not match published_entry domain")
        end
      end
    end
  end

end
