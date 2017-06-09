# == Schema Information
#
# Table name: menus
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  domain_id                :uuid             not null
#  order                    :integer
#  menu_group_ordering      :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Menu < ActiveRecord::Base
  include SetCreator
  include Ordering

  # default_scope { order(order: :asc) }

  belongs_to :domain
  belongs_to :creator, class_name: "User"
  has_many :menu_groups

  validates :text, uniqueness: {scope: :domain_id, message: "Menu text must be unique within a Domain"}
  validates :domain_id, presence: :true
  validates :order, uniqueness: {scope: :domain_id, message: "Menu order must be unique within a Domain"}, allow_blank: true

  ORDERING_CHILD = "MenuGroup"
  PUBLISHED_ENTRY_PARENTS = ['MenuGroup', 'Topic']

end
