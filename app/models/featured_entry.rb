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
#  order                      :integer
#  published_at               :datetime
#  type                       :string
#  revised_published_entry_id :uuid
#  removed                    :boolean          default(FALSE)
#  creator_id                 :uuid             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class FeaturedEntry < PublishedEntry

  default_scope { order("data ->> 'published_at' DESC") }

  belongs_to :revised_featured_entry, class_name: 'FeaturedEntry', foreign_key: 'revised_published_entry_id'
  has_one :previous_featured_entry, class_name: 'FeaturedEntry', foreign_key: 'revised_published_entry_id'

  validate :valid_data

  # Clear out old join models
  def menu_group_published_entry_topics_attributes=(*args)
    self.menu_group_published_entry_topics.clear
    super(*args)
  end

  # For date_range concern
  def self.default_date_attribute
    "data ->> 'published_at'"
  end

  protected

  def valid_data
    # Data needs to have published_at key
    if self.data.nil?
      errors.add(:data, 'Data Error: Data is nil')
    else
      if !self.data.has_key?('published_at') || data['published_at'].nil?
        errors.add(:published_at, 'Data Error: FeaturedEntry data object required published_at')
      end
    end
  end

end
