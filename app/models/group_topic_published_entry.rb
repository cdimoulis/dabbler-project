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
  belongs_to :topic
  belongs_to :published_entry

  validates :group_id, :published_entry_id, presence: true
  validate :valid_group, :valid_domain


  protected

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

end
