class CreateGroupsMenus < ActiveRecord::Migration
  def change
    create_join_table :groups, :menus, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :menu_id, null: false
      t.uuid :group_id, null: false
    end

    add_index :groups_menus, :menu_id
    add_index :groups_menus, :group_id
    add_index :groups_menus, [:menu_id, :group_id]
  end
end
