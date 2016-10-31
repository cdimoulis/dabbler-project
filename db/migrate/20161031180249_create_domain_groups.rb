class CreateDomainGroups < ActiveRecord::Migration
  def change
    create_table :domain_groups do |t|
      t.string :text, null: false
      t.text :description
      t.belongs_to :domain, index: true

      t.timestamps null: false
    end
  end
end
