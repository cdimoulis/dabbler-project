# == Schema Information
#
# Table name: menus_menu_groups
#
#  id            :uuid             not null, primary key
#  menu_id       :uuid             not null
#  menu_group_id :uuid             not null
#

####
# The purpose of this join is because menu_group is a child of group which
# does not have a belong to with menus. 
###
class MenusMenuGroup < ActiveRecord::Base

  belongs_to :menu_group
  belongs_to :menu

  validates :menu_group_id, :menu_id, presence: true
  validate :group_type, :domain_match, :unique_order

  protected
  # All MenuGroups part of a menu should have a unique ordering
  def unique_order
    # All records for this menu_id
    menu_records = MenusMenuGroup.where(menu_id: menu_id)
    # All ids for menu_groups EXCEPT self.menu_group_id
    group_ids = menu_records.pluck('menu_group_id') - [menu_group_id]
    # All group records corresponding to ids
    groups = MenuGroup.where(id: group_ids)
    # Array of orders existing for this menu
    orders = groups.pluck('order')
    # The order of this menu_group
    menu_group = MenuGroup.where(id: menu_group_id).take
    if menu_group.present?
      order = menu_group.order
      # If this order is included in the array of orders the order is invalid
      if orders.include?(order)
        errors.add(:menu_group_id, "Group order must be unique within a Menu")
      end
    end
  end

  def group_type
    if attribute_present?(:menu_group_id)
      menu_group = Group.where('id = ?',menu_group_id).take
      if menu_group.present? and menu_group.type != "MenuGroup"
        errors.add(:menu_group_id, 'Group type must be MenuGroup')
      end
    end
  end

  def domain_match
    if attribute_present?(:menu_group_id) and attribute_present?(:menu_id)
      menu_group = Group.where('id = ?',menu_group_id).take
      menu = Menu.where('id = ?', menu_id).take
      if menu.present? and menu_group.present? and (menu_group.domain_id != menu.domain_id)
        errors.add(:menu_id, 'Group and Menu Domain must be same')
      end
    end
  end

end
