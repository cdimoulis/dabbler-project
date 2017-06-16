# == Schema Information
#
# Table name: topics
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  menu_group_id            :uuid             not null
#  order                    :integer
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Topic < ApplicationRecord
  include SetCreator
  include Ordering

  belongs_to :menu_group
  belongs_to :creator, class_name: "User"
  has_many :published_entries_topics
  has_many :published_entries, through: :published_entries_topics

  validates :text, :menu_group_id, :creator_id, presence: true
  validates :text, uniqueness: {scope: :menu_group_id, message: "Topic text must be unique within MenuGroup"}
  validates :order, uniqueness: {scope: :menu_group_id, message: "Topic order must be unique within a MenuGroup"}, allow_blank: true
  validate :menu_group_exists

  protected

  def menu_group_exists
    if attribute_present?(:menu_group_id) and !MenuGroup.exists?(menu_group_id)
      errors.add(:menu_group_id, "Topic Model: Invalid MenuGroup: Does not exist")
    end
  end

end
