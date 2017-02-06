# == Schema Information
#
# Table name: entries
#
#  id                :uuid             not null, primary key
#  text              :string           not null
#  description       :text
#  author_id         :uuid             not null
#  default_image_url :string
#  content           :text             not null
#  updated_entry_id  :uuid
#  locked            :boolean          default(FALSE)
#  remove            :boolean          default(FALSE)
#  creator_id        :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Entry < ApplicationRecord

  default_scope { order(text: :asc) }

  belongs_to :author, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :contributors, class_name: 'User'
  belongs_to :updated_entry, class_name: 'Entry', foreign_key: 'updated_entry_id'
  has_one :previous_entry, class_name: 'Entry', foreign_key: 'updated_entry_id'
  has_many :published_entries
  has_many :featured_entries
  has_many :tutorial_entries

  validates :text, :author_id, :content, presence: true
  validate :author_exists

  ###
  # Scopes
  ###
  def self.unpublished
    entry_ids = PublishedEntry.pluck('entry_id').uniq
    where.not(id: entry_ids)
  end
  ###
  # End Scopes
  ###


  protected

  def author_exists
    if attribute_present?(:author_id) and !User.exists?(author_id)
      errors.add(:author_id, "Invalid Author: Does not exists")
    end
  end

end
