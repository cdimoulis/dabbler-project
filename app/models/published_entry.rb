# == Schema Information
#
# Table name: published_entries
#
#  id               :uuid             not null, primary key
#  author_id        :uuid             not null
#  domain_id        :uuid             not null
#  entry_id         :uuid             not null
#  image_url        :string
#  notes            :text
#  tags             :text             is an Array
#  publishable_id   :uuid
#  publishable_type :string
#  creator_id       :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class PublishedEntry < ActiveRecord::Base

  default_scope { order(created_at: :asc) }

  belongs_to :author, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  belongs_to :domain
  belongs_to :entry
  belongs_to :publishable, polymorphic: true

  before_validation :set_author

  validates :author_id, :domain_id, :entry_id, presence: true
  validate :entry_author, :domain_exists

  private

  def set_author
    if author_id.nil? and !entry.nil?
      self.author_id = entry.author_id
    end
  end

  def entry_author
    if attribute_present?(:author_id) and attribute_present?(:entry_id)
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
