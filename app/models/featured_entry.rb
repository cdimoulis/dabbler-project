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

class FeaturedEntry < PublishedEntry

  default_scope { order("data ->> 'published_at' DESC") }

  validate :valid_data

  # Clear out old join models
  def group_topic_published_entries_attributes=(*args)
    self.group_topic_published_entries.clear
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
