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
  include SetCreator

  default_scope { order(text: :asc) }

  belongs_to :author, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :contributors, class_name: 'User'
  belongs_to :updated_entry, class_name: 'Entry', foreign_key: 'updated_entry_id'
  has_one :previous_entry, class_name: 'Entry', foreign_key: 'updated_entry_id'
  has_many :published_entries
  has_many :featured_entries

  after_update :replace_associations
  before_destroy :check_update

  validates :text, :author_id, :content, presence: true
  validate :author_exists

  ###
  # Scopes
  ###
  # Entries that are not part of a PublishedEntry
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

  # Link together updated entries on destroy
  def check_update
    # If this model has updated a previous entry
    if previous_entry.present?
      # If there is an update of this entry then set it as the update of the previous_entry
      if updated_entry.present?
        previous_entry.updated_entry = updated_entry
        if !(previous_entry.valid? and previous_entry.save)
          puts "\n\nCould not link previous and updated entries\n#{previous_entry.errors.inspect}\n\n"
          Rails.logger.info "\n\nCould not link previous and updated entries\n#{previous_entry.errors.inspect}\n\n"
        end
      else
        # Nullify the previous_entry.updated_entry_id
        previous_entry.updated_entry_id = nil
        if !(previous_entry.valid? and previous_entry.save)
          puts "\n\nCould not nullify previous_entry updated entry\n#{previous_entry.errors.inspect}\n\n"
          Rails.logger.info "\n\nCould not nullify previous_entry updated entry\n#{previous_entry.errors.inspect}\n\n"
        end
      end
    end
  end

  # Replace associations on update
  def replace_associations
    if updated_entry.present?
      published_entries.each do |pe|
        pe.entry = updated_entry
        pe.author = updated_entry.author
        if !(pe.valid? && pe.save)
          puts "\n\nCould not update published entry for entry #{self.inspect}:\n#{pe.errors.inspect}\n\n"
          Rails.logger.info "\n\nCould not update published entry for entry #{self.inspect}:\n#{pe.errors.inspect}\n\n"
        end
      end
    end
  end
end
