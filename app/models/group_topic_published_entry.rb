# == Schema Information
#
# Table name: group_topic_published_entries
#
#  id                 :uuid             not null, primary key
#  group_id           :uuid             not null
#  topic_id           :uuid
#  published_entry_id :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class GroupTopicPublishedEntry < ApplicationRecord

  belongs_to :group
  belongs_to :featured_group, foreign_key: 'group_id'
  belongs_to :tutorial_group, foreign_key: 'group_id'
  belongs_to :topic
  belongs_to :published_entry
  belongs_to :featured_entry, foreign_key: 'published_entry_id'
  belongs_to :tutorial_entry, foreign_key: 'published_entry_id'

  before_validation :set_group

  validates :group_id, :published_entry, presence: true
  validate :valid_group, :valid_domain, :valid_types


  protected

  def set_group
    # If no group_id and topic is not nil, then set group from topic
    if !attribute_present?(:group_id) and !topic.nil?
      self.group_id = topic.group_id
    end
  end

  def valid_group
    if !topic.nil?
      if topic.group != group
        errors.add(:topic_id, "GroupTopicPublishedEntry Model: topic group does not match group_id")
      end
    end
  end

  def valid_domain
    if !group.nil? and !published_entry.nil?
      if group.domain != published_entry.domain
        errors.add(:group_id, "GroupTopicPublishedEntry Model: group domain does not match published_entry domain")
      end
    end
  end

  def valid_types
    if (published_entry.type == "FeaturedEntry") && (group.type != "FeaturedGroup")
      errors.add(:types, "Type Missmatch error: Published entry is #{published_entry.type} but group is #{group.type}")
    elsif (published_entry.type == "TutorialEntry") && (group.type != "TutorialGroup")
      errors.add(:types, "Type Missmatch error: Published entry is #{published_entry.type} but group is #{group.type}")
    end
  end

end
