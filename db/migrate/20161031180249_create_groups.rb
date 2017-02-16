class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, null: false
      t.integer :order, null: false
      t.string :type, null: false

      t.timestamps null: false
    end

    add_index :groups, :text
    add_index :groups, :domain_id
    add_index :groups, [:domain_id, :type, :text], unique: true
  end
end
