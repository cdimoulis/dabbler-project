# == Schema Information
#
# Table name: menus_menu_groups
#
#  id            :uuid             not null, primary key
#  menu_id       :uuid             not null
#  menu_group_id :uuid             not null
#

class MenusMenuGroup < ActiveRecord::Base

  belongs_to :menu_group
  belongs_to :menu

  validates :menu_group_id, :menu_id, presence: true
  validate :group_type, :domain_match

  protected

  def group_type
    if menu_group.type != "MenuGroup"
      errors.add(:menu_group_id, 'Group type must be MenuGroup')
    end
  end

  def domain_match
    if menu_group.domain_id != menu.domain_id
      errors.add(:menu_id, 'Group and Menu Domain must be same')
    end
  end

end
