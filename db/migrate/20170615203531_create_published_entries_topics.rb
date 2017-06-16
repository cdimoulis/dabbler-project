class CreatePublishedEntriesTopics < ActiveRecord::Migration
  def change
    create_table :published_entries_topics, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :published_entry_id
      t.uuid :topic_id
      
      t.timestamps null: false
    end
  end
end
