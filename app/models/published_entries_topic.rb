# == Schema Information
#
# Table name: published_entries_topics
#
#  id                 :uuid             not null, primary key
#  published_entry_id :uuid
#  topic_id           :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PublishedEntriesTopic < ActiveRecord::Base

  belongs_to :published_entry
  belongs_to :topic

  validates :published_entry_id, :topic_id, presence: true
  validates :published_entry_id, uniqueness: { scope: :topic_id }, message: "PublishedEntry can only be in a topic once"
  validate :same_domain

  protected

  def same_domain
    if published_entry.present? and topic.present? and published_entry.domain.present? and topic.domain.present?
      if published_entry.domain.id != topic.domain.id
        errors.add(:domain, "PublishedEntry domain does not match Topic")
      end
    end
  end

end
