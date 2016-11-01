class CreateDomainGroups < ActiveRecord::Migration
  def change
    create_table :domain_groups do |t|
      t.string :text, null: false
      t.text :description
      t.uuid :domain_id, index: true, null: false

      t.timestamps null: false
    end
  end
end
