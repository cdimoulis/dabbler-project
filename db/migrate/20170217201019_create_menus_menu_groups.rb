class CreateMenusMenuGroups < ActiveRecord::Migration
  def change
    create_table :menus_menu_groups, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :menu_id, null: false
      t.uuid :menu_group_id, null: false
    end

    add_index :menus_menu_groups, :menu_id
    add_index :menus_menu_groups, :menu_group_id
    add_index :menus_menu_groups, [:menu_id, :menu_group_id]
  end
end
