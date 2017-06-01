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

class MenuGroup < ApplicationRecord

  # default_scope { order(text: :asc) }

  belongs_to :domain
  belongs_to :menu
  has_many :topics
  has_many :menu_group_published_entry_topics
  has_many :published_entries, through: :menu_group_published_entry_topics
  # has_many :menu_entries, through: :group_topic_published_entries, foreign_key: 'published_entry_id'

  validates :text, :domain_id, :menu_id, presence: true
  validates :text, uniqueness: {scope: [:menu_id], message: "MenuGroup text must be unique within a Menu"}
  validate :domain_exists, :menu_exists, :unique_order, :domain_match


  protected

  def domain_exists
    if attribute_present?(:domain_id) and !Domain.exists?(domain_id)
      errors.add(:domain_id, "Invalid Domain: Does not exist")
    end
  end

  def menu_exists
    if attribute_present?(:menu_id) and !Menu.exists?(menu_id)
      errors.add(:menu_id, "Invalid Menu: Does not exist")
    end
  end

  def domain_match
    if attribute_present?(:menu_id) and attribute_present?(:domain_id)
      if menu.present? and (menu.domain_id != domain_id)
        errors.add(:menu_id, 'MenuGroup and Menu Domain must be same')
      end
    end
  end

  # All MenuGroups part of a menu should have a unique ordering
  def unique_order
    # Array of orders existing for this menu
    orders = menu.menu_groups.pluck('order')
    # The order of this menu_group
    if orders.include?(order)
      errors.add(:menu_group_id, "MenuGroup order must be unique within a Menu")
    end
  end

end
