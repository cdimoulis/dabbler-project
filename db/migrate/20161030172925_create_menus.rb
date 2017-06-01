class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, null: false
      t.integer :order, null: false
      t.string :menu_group_order, default: 'text'

      t.timestamps null: false
    end

    add_index :menus, :text
    add_index :menus, :domain_id
  end
end
