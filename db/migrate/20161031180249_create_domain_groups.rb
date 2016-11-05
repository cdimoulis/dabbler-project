class CreateDomainGroups < ActiveRecord::Migration
  def change
    create_table :domain_groups, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, index: true, null: false

      t.timestamps null: false
    end

    add_index :domain_groups, :text
    add_index :domain_groups, [:domain_id, :text], unique: true
  end
end
