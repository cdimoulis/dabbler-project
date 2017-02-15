# == Schema Information
#
# Table name: published_entries
#
#  id                         :uuid             not null, primary key
#  author_id                  :uuid             not null
#  domain_id                  :uuid             not null
#  entry_id                   :uuid             not null
#  image_url                  :string
#  notes                      :text
#  tags                       :text             is an Array
#  type                       :string
#  data                       :json
#  revised_published_entry_id :uuid
#  removed                    :boolean          default(FALSE)
#  creator_id                 :uuid             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class PublishedEntry < ApplicationRecord
  include AssociationAccessors

  belongs_to :author, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  belongs_to :domain
  belongs_to :entry

  has_many :group_topic_published_entries, dependent: :destroy, inverse_of: :published_entry
  has_many :groups, through: :group_topic_published_entries
  has_many :topics, through: :group_topic_published_entries
  belongs_to :revised_published_entry, class_name: 'PublishedEntry', foreign_key: 'revised_published_entry_id'
  has_one :previous_published_entry, class_name: 'PublishedEntry', foreign_key: 'revised_published_entry_id'

  accepts_nested_attributes_for :group_topic_published_entries

  before_validation :set_author
  before_destroy :check_revision
  after_create :lock_entry

  validates :author_id, :domain_id, :entry_id, presence: true
  validate :entry_author, :domain_exists, :revision_type

  ###
  # Scopes
  ###
  scope :current, -> { where(revised_published_entry_id: nil) }

  ###
  # End Scopes
  ###

  # Clear out old join models when setting new ones
  def group_topic_published_entries_attributes=(*args)
    self.group_topic_published_entries.clear
    super(*args)
  end


  ###
  # For AssociationAccessors concern
  ###
  def association_attributes
    {:entry => [:text]}
  end

  def send_attributes
    [:text, :group_topic_published_entries]
  end
  ###
  # End AssociationAccessorconcern
  ###

  protected

  def check_revision
    # If this model has revised a previous published_entry
    if previous_published_entry.present?
      # If there is a revision of this published entry then set it as the revision of the previous
      if revised_published_entry.present?
        previous_published_entry.revised_published_entry = revised_published_entry
        if !(previous_published_entry.valid? and previous_published_entry.save)
          puts "\n\nCould not link previous and revised published entries\n#{previous_published_entry.errors.inspect}\n\n"
          Rails.logger.info "\n\nCould not link previous and revised published entries\n#{previous_published_entry.errors.inspect}\n\n"
        end
      else
        # Nullify the previous_published_entry.revised_published_entry_id
        previous_published_entry.revised_published_entry_id = nil
        if !(previous_published_entry.valid? and previous_published_entry.save)
          puts "\n\nCould not nullify previous_published_entry revised entry\n#{revised_published_entry.errors.inspect}\n\n"
          Rails.logger.info "\n\nCould not nullify previous_published_entry revised entry\n#{revised_published_entry.errors.inspect}\n\n"
        end
      end
    end
  end

  def lock_entry
    if not entry.locked
      entry.locked = true
      entry.save
    end
  end

  private

  def set_author
    if author_id.nil? and entry.present?
      self.author_id = entry.author_id
    end
  end

  def entry_author
    if attribute_present?(:author_id) and entry.present?
      if author_id != entry.author_id
        errors.add(:author_id, "Is not the same as Entry author")
        puts "\n\nPublishedEntry error: Invalid author_id #{author_id}\nEntry:#{entry.inspect}\n\n"
        Rails.logger.info "\n\nPublishedEntry error: Invalid author_id #{author_id}\nEntry:#{entry.inspect}\n\n"
      end
    end
  end

  def domain_exists
    if attribute_present?(:domain_id) and !Domain.exists?(domain_id)
      errors.add(:domain_id, "Invalid Domain: Does not exist")
      puts "\n\nPublishedEntry error: Invalid domain_id #{domain_id}\nEntry:#{entry.inspect}\n\n"
      Rails.logger.info "\n\nPublishedEntry error: Invalid domain_id #{domain_id}\nEntry:#{entry.inspect}\n\n"
    end
  end

  def revision_type
    if revised_published_entry.present?
      if revised_published_entry.type != type
        errors.add(:revised_published_entry_id, "New revised published entry type #{revised_published_entry.type} does not match #{type}")
        puts "\n\nPublishedEntry error: Invalid revised_published_entry type #{revised_published_entry.type} compared to #{type}\n\n"
        Rails.logger.info "\n\nPublishedEntry error: Invalid revised_published_entry type #{revised_published_entry.type} compared to #{type}\n\n"
      end
    end
  end

end
