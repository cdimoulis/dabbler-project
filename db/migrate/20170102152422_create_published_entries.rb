class CreatePublishedEntries < ActiveRecord::Migration
  def change
    create_table :published_entries, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :author_id, null: false
      t.uuid :domain_id, null: false
      t.uuid :group_id, null: false
      t.uuid :topic_id, null: false
      t.uuid :entry_id, null: false
      t.string :image_url
      t.array :tags

      t.uuid :publishable_id
      t.string :publishable_type

      t.timestamps null: false
    end

    add_index :published_entries, :author_id
    add_index :published_entries, :creator_id
    add_index :published_entries, :domain_id
    add_index :published_entries, :group_id
    add_index :published_entries, :topic_id
    add_index :published_entries, :entry_id
    add_index :published_entries, :publishable_id
  end
end
