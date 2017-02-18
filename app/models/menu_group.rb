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

  has_one :menus_menu_group
  has_one :menu, through: :menus_menu_group
  # has_many :menu_entries, through: :group_topic_published_entries, foreign_key: 'published_entry_id'

  validate :valid_order

  protected

  def valid_order
    if menus_menu_group.present? && !menus_menu_group.valid?
      errors.add(:order, 'Order must be unique within a Menu')
    end
  end

end
