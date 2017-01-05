class CreateGroupTopicPublishedEntries < ActiveRecord::Migration
  def change
    create_table :group_topic_published_entries, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :group_id, null: false
      t.uuid :topic_id
      t.uuid :published_entry_id, null: false

      t.timestamps null: false
    end

    add_index :group_topic_published_entries, :group_id
    add_index :group_topic_published_entries, :topic_id
    add_index :group_topic_published_entries, :published_entry_id
  end
end
