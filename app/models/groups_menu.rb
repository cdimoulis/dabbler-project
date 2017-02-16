# == Schema Information
#
# Table name: groups_menus
#
#  group_id :uuid             not null
#  menu_id  :uuid             not null
#

class GroupsMenu < ActiveRecord::Base

  belongs_to :group
  belongs_to :menu

  validates :group_id, :menu_id, presence: true
  validate :group_type

  protected

  def group_type
    if group.type != "MenuGroup"
      errors.add(:group_id, 'Group type must be MenuGroup')
    end
  end

end
