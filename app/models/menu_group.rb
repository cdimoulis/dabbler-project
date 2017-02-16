# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  order       :integer          not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MenuGroup < Group

  default_scope { order(order: :asc) }

  # has_one :menu, through: menus_menu_groups
  # has_many :menu_entries, through: :group_topic_published_entries, foreign_key: 'published_entry_id'

  # validates :order, uniqueness: {scope: :menu, message: "MenuGroup order must be unique within a Menu"}
end
