class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.string :subdomain, null: false
      t.boolean :active, default: true
      t.text :menu_ordering, default: ['order:asc', 'text:asc'], array: true
      t.text :published_entry_ordering, default: ['published_at:desc'], array: true
      t.uuid :creator_id, null: false   # The logged in user

      t.timestamps null: false
    end

    add_index :domains, :text
    add_index :domains, :subdomain
    add_index :domains, :creator_id
  end
end
