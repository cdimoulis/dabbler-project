class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries, id: :uuid, default: "uuid_generate_v4()", force: true do |t|

      t.timestamps null: false
    end
  end
end
