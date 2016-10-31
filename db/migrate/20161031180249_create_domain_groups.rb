class CreateDomainGroups < ActiveRecord::Migration
  def change
    create_table :domain_groups do |t|

      t.timestamps null: false
    end
  end
end
