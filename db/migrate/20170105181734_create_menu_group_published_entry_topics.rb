class CreateMenuGroupPublishedEntryTopics < ActiveRecord::Migration
  def change
    create_table :menu_group_published_entry_topics, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :menu_group_id, null: false
      t.uuid :topic_id
      t.uuid :published_entry_id, null: false

      t.timestamps null: false
    end

    add_index :menu_group_published_entry_topics, :menu_group_id
    add_index :menu_group_published_entry_topics, :topic_id
    add_index :menu_group_published_entry_topics, :published_entry_id
  end
end
