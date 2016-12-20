class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text  :description
      t.uuid :author_id, null: false  # The user who is given main authorship credit
      t.string :default_image_url
      t.text :content, null: false
      t.boolean :remove, default: false
      t.uuid :creator_id, null: false   # The logged in user

      t.timestamps null: false
    end
    
    add_index :entries, :text
    add_index :entries, :author_id
    add_index :entries, :creator_id
  end
end
