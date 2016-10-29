class CreateDomain < ActiveRecord::Migration
  def change
    create_table :domains, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :text, null: false
    end
  end
end
