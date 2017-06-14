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

  belongs_to :revised_featured_entry, class_name: 'FeaturedEntry', foreign_key: 'revised_published_entry_id'
  has_one :previous_featured_entry, class_name: 'FeaturedEntry', foreign_key: 'revised_published_entry_id'

  # Clear out old join models
  def menu_group_published_entry_topics_attributes=(*args)
    self.menu_group_published_entry_topics.clear
    super(*args)
  end

  # For date_range concern
  def self.default_date_attribute
    "published_at"
  end

  protected

end
