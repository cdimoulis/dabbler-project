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

class TutorialEntry < PublishedEntry

  default_scope { order("data ->> 'order' ASC")}

  has_many :tutorial_groups, through: :group_topic_published_entries, foreign_key: 'group_id'
  belongs_to :revised_tutorial_entry, class_name: 'TutorialEntry', foreign_key: 'revised_published_entry_id'
  has_one :previous_tutorial_entry, class_name: 'TutorialEntry', foreign_key: 'revised_published_entry_id'

  validate :valid_data

  # Clear out old join models
  def group_topic_published_entries_attributes=(*args)
    self.group_topic_published_entries.clear
    super(*args)
  end


  protected

  def valid_data
    # Data needs to have published_at key
    if self.data.nil?
      errors.add(:data, 'Data Error: Data is nil')
    else
      if !self.data.has_key?('order') || data['order'].nil?
        errors.add(:order, 'Data Error: FeaturedEntry data object required order')
      end
    end
  end

end
