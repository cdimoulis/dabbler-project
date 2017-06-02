class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, null: false
      t.integer :order, null: false
      t.string :menu_group_order, default: 'text'
      t.uuid :creator_id, null: false   # The logged in user

      t.timestamps null: false
    end

    add_index :menus, :text
    add_index :menus, :domain_id
  end
end
