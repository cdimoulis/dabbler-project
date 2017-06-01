class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, null: false
      t.uuid :menu_group_id, null: false
      t.uuid :creator_id, null: false   # The logged in user

      t.timestamps null: false
    end

    add_index :topics, :text
    add_index :topics, :domain_id
    add_index :topics, :menu_group_id
    add_index :topics, :creator_id
    add_index :topics, [:text, :menu_group_id], unique: true
  end
end
