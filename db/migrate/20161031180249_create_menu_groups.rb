class CreateMenuGroups < ActiveRecord::Migration
  def change
    create_table :menu_groups, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, null: false
      t.uuid :menu_id, null: false
      t.integer :order

      t.timestamps null: false
    end

    add_index :menu_groups, :text
    add_index :menu_groups, :domain_id
    add_index :menu_groups, :menu_id
    add_index :menu_groups, [:menu_id, :text], unique: true
    add_index :menu_groups, [:domain_id, :menu_id]
  end
end
