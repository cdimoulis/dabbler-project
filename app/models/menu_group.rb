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

  belongs_to :creator, class_name: "User"
  belongs_to :menu
  has_one :domain, through: :menu
  has_many :topics

  validates :text, :menu_id, presence: true
  validates :text, uniqueness: {scope: [:menu_id], message: "MenuGroup text must be unique within a Menu"}
  validates :order, uniqueness: {scope: :menu_id, message: "MenuGroup order must be unique within a Menu"}, allow_blank: true
  validate :menu_exists

  ORDERING_CHILD = "Topic"
  PUBLISHED_ENTRY_PARENTS = ['Topic']

  protected

  def menu_exists
    if attribute_present?(:menu_id) and !Menu.exists?(menu_id)
      errors.add(:menu_id, "Invalid Menu: Does not exist")
    end
  end

end
