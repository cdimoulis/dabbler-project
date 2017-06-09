# == Schema Information
#
# Table name: menu_groups
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  menu_id                  :uuid             not null
#  order                    :integer
#  topic_ordering           :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class MenuGroup < ApplicationRecord
  include SetCreator
  include Ordering

  belongs_to :menu
  belongs_to :creator, class_name: "User"
  has_many :topics
  has_many :menu_group_published_entry_topics
  has_many :published_entries, through: :menu_group_published_entry_topics

  validates :text, :menu_id, presence: true
  validates :text, uniqueness: {scope: [:menu_id], message: "MenuGroup text must be unique within a Menu"}
  validate :menu_exists, :unique_order

  ORDERING_CHILD = "Topic"
  PUBLISHED_ENTRY_PARENTS = ['Topic']

  protected

  def menu_exists
    if attribute_present?(:menu_id) and !Menu.exists?(menu_id)
      errors.add(:menu_id, "Invalid Menu: Does not exist")
    end
  end

  # All MenuGroups part of a menu should have a unique ordering
  def unique_order
    m = Menu.where("id = ?", menu_id).take
    # Array of orders existing for this menu
    if m.present?
      orders = m.menu_groups.pluck('order')
      # The order of this menu_group
      if orders.include?(order)
        errors.add(:menu_group_id, "MenuGroup order must be unique within a Menu")
      end
    end
  end

end
