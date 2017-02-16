class CreateEntriesUsers < ActiveRecord::Migration
  def change
    create_join_table :entries, :users, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.uuid :entry_id, null: false
      t.uuid :user_id, null: false
    end

    add_index :entries_users, :entry_id
    add_index :entries_users, :user_id
    add_index :entries_users, [:entry_id, :user_id]
  end
end
