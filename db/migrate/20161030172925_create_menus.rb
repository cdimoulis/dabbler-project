class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, null: false
      t.integer :order
      t.text :menu_group_ordering, default: ['order:asc', 'text:asc'], array: true
      t.uuid :creator_id, null: false   # The logged in user

      t.timestamps null: false
    end

    add_index :menus, :text
    add_index :menus, :domain_id
    add_index :menus, :creator_id
    add_index :menus, [:text, :domain_id], unique: true
  end
end
