# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161113210427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "admins", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email",                               null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.uuid     "person_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree

  create_table "domain_groups", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",        null: false
    t.text     "description"
    t.uuid     "domain_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "domain_groups", ["domain_id", "text"], name: "index_domain_groups_on_domain_id_and_text", unique: true, using: :btree
  add_index "domain_groups", ["domain_id"], name: "index_domain_groups_on_domain_id", using: :btree
  add_index "domain_groups", ["text"], name: "index_domain_groups_on_text", using: :btree

  create_table "domains", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",                       null: false
    t.text     "description"
    t.string   "subdomain",                  null: false
    t.boolean  "active",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "domains", ["subdomain"], name: "index_domains_on_subdomain", unique: true, using: :btree
  add_index "domains", ["text"], name: "index_domains_on_text", unique: true, using: :btree

  create_table "people", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "gender"
    t.date     "birth_date"
    t.string   "phone"
    t.string   "address_one"
    t.string   "address_two"
    t.string   "city"
    t.string   "state_region"
    t.string   "country"
    t.string   "postal_code"
    t.string   "facebook_id"
    t.string   "facebook_link"
    t.string   "twitter_id"
    t.string   "twitter_screen_name"
    t.string   "instagram_id"
    t.string   "instagram_username"
    t.uuid     "creator_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "people", ["creator_id"], name: "index_people_on_creator_id", using: :btree

end
