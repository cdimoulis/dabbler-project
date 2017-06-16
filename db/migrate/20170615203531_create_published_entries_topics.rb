class CreatePublishedEntriesTopics < ActiveRecord::Migration
  def change
    create_table :published_entries_topics, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :published_entry_id, null: false
      t.uuid :topic_id, null: false
      t.uuid :order

      t.timestamps null: false
    end

    add_index :published_entries_topics, :published_entry_id
    add_index :published_entries_topics, :topic_id
    add_index :published_entries_topics, [:published_entry_id, :topic_id], unique: true, name: 'index_published_entry_id_and_topic_id'
  end
end
