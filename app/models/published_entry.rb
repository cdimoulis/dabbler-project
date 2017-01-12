# == Schema Information
#
# Table name: published_entries
#
#  id         :uuid             not null, primary key
#  author_id  :uuid             not null
#  domain_id  :uuid             not null
#  entry_id   :uuid             not null
#  image_url  :string
#  notes      :text
#  tags       :text             is an Array
#  type       :string
#  data       :json
#  creator_id :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PublishedEntry < ApplicationRecord
  include AssociationAccessors

  belongs_to :author, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  belongs_to :domain
  belongs_to :entry
  belongs_to :publishable, polymorphic: true

  has_many :group_topic_published_entries, dependent: :destroy
  has_many :groups, through: :group_topic_published_entries
  has_many :topics, through: :group_topic_published_entries

  before_validation :set_author

  validates :author_id, :domain_id, :entry_id, presence: true
  validate :entry_author, :domain_exists

  ###
  # For AssociationAccessors concern
  ###
  def association_attributes
    {:entry => [:text]}
  end

  def send_attributes
    [:text]
  end
  ###
  # End AssociationAccessorconcern
  ###

  protected

  private

  def set_author
    if author_id.nil? and !entry.nil?
      self.author_id = entry.author_id
    end
  end

  def entry_author
    if attribute_present?(:author_id) and !entry.nil?
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
    end
  end

end
