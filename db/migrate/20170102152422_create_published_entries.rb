class CreatePublishedEntries < ActiveRecord::Migration
  def change
    create_table :published_entries, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :author_id, null: false
      t.uuid :domain_id, null: false
      t.uuid :entry_id, null: false
      t.string :image_url
      t.text :notes
      t.text :tags, array: true
      t.string :type
      t.json :data
      t.uuid :revised_published_entry_id
      t.boolean :removed, default: false

      t.uuid :creator_id, null: false   # The logged in user who actually published this
      t.timestamps null: false
    end

    add_index :published_entries, :author_id
    add_index :published_entries, :creator_id
    add_index :published_entries, :domain_id
    add_index :published_entries, :entry_id
    add_index :published_entries, :revised_published_entry_id
  end
end
