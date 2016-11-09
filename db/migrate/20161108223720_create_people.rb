class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :prefix
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix
      t.string :gender
      t.date :birth_date
      t.string :phone
      t.string :address_one
      t.string :address_two
      t.string :city
      t.string :state_region
      t.string :country
      t.string :postal_code
      t.string :facebook_id
      t.string :facebook_link
      t.string :twitter_id
      t.string :twitter_screen_name
      t.string :instagram_id
      t.string :instagram_username

      t.uuid :creator_id
      t.timestamps null: false
    end

    add_index :people, :creator_id
  end
end
