class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.string :subdomain, null: false
      t.boolean :active, default: true

      t.timestamps null: false
    end
    add_index :domains, :text
  end
end
