# == Schema Information
#
# Table name: group_topic_published_entries
#
#  id                 :uuid             not null, primary key
#  group_id           :uuid
#  topic_id           :uuid
#  published_entry_id :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class GroupTopicPublishedEntry < ActiveRecord::Base

  belongs_to :group
  belongs_to :topic
  belongs_to :published_entry

  validate :topic_group


  protected

  def topic_group
    if !topic.nil?
      if !(topic.group == group)
        errors.add(:topic_id, "GroupTopicPublishedEntry Model: topic group does not match group_id")
      end
    end
  end
end
