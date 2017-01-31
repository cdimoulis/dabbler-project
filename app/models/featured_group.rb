# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FeaturedGroup < Group

  has_many :featured_entries, through: :group_topic_published_entries, foreign_key: 'published_entry_id'

end
