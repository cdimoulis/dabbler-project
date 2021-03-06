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

ActiveRecord::Schema.define(version: 20170615203531) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "domains", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",                                              null: false
    t.text     "description"
    t.string   "subdomain",                                         null: false
    t.boolean  "active",        default: true
    t.text     "menu_ordering", default: ["order:asc", "text:asc"],              array: true
    t.uuid     "creator_id",                                        null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "domains", ["creator_id"], name: "index_domains_on_creator_id", using: :btree
  add_index "domains", ["subdomain"], name: "index_domains_on_subdomain", using: :btree
  add_index "domains", ["text"], name: "index_domains_on_text", using: :btree

  create_table "entries", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",                              null: false
    t.text     "description"
    t.uuid     "author_id",                         null: false
    t.string   "default_image_url"
    t.text     "content",                           null: false
    t.uuid     "updated_entry_id"
    t.boolean  "locked",            default: false
    t.boolean  "remove",            default: false
    t.uuid     "creator_id",                        null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "entries", ["author_id"], name: "index_entries_on_author_id", using: :btree
  add_index "entries", ["creator_id"], name: "index_entries_on_creator_id", using: :btree
  add_index "entries", ["text"], name: "index_entries_on_text", using: :btree
  add_index "entries", ["updated_entry_id"], name: "index_entries_on_updated_entry_id", using: :btree

  create_table "entries_users", id: false, force: :cascade do |t|
    t.uuid "entry_id", null: false
    t.uuid "user_id",  null: false
  end

  add_index "entries_users", ["entry_id", "user_id"], name: "index_entries_users_on_entry_id_and_user_id", using: :btree
  add_index "entries_users", ["entry_id"], name: "index_entries_users_on_entry_id", using: :btree
  add_index "entries_users", ["user_id"], name: "index_entries_users_on_user_id", using: :btree

  create_table "menu_groups", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",                                               null: false
    t.text     "description"
    t.uuid     "menu_id",                                            null: false
    t.integer  "order"
    t.text     "topic_ordering", default: ["order:asc", "text:asc"],              array: true
    t.uuid     "creator_id",                                         null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "menu_groups", ["creator_id"], name: "index_menu_groups_on_creator_id", using: :btree
  add_index "menu_groups", ["menu_id", "text"], name: "index_menu_groups_on_menu_id_and_text", unique: true, using: :btree
  add_index "menu_groups", ["menu_id"], name: "index_menu_groups_on_menu_id", using: :btree
  add_index "menu_groups", ["order"], name: "index_menu_groups_on_order", using: :btree
  add_index "menu_groups", ["text"], name: "index_menu_groups_on_text", using: :btree

  create_table "menus", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",                                                    null: false
    t.text     "description"
    t.uuid     "domain_id",                                               null: false
    t.integer  "order"
    t.text     "menu_group_ordering", default: ["order:asc", "text:asc"],              array: true
    t.uuid     "creator_id",                                              null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "menus", ["creator_id"], name: "index_menus_on_creator_id", using: :btree
  add_index "menus", ["domain_id"], name: "index_menus_on_domain_id", using: :btree
  add_index "menus", ["order"], name: "index_menus_on_order", using: :btree
  add_index "menus", ["text", "domain_id"], name: "index_menus_on_text_and_domain_id", unique: true, using: :btree
  add_index "menus", ["text"], name: "index_menus_on_text", using: :btree

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

  create_table "published_entries", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "author_id",                                  null: false
    t.uuid     "domain_id",                                  null: false
    t.uuid     "entry_id",                                   null: false
    t.string   "image_url"
    t.text     "notes"
    t.text     "tags",                                                    array: true
    t.datetime "published_at"
    t.string   "type"
    t.uuid     "revised_published_entry_id"
    t.boolean  "removed",                    default: false
    t.uuid     "creator_id",                                 null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "published_entries", ["author_id"], name: "index_published_entries_on_author_id", using: :btree
  add_index "published_entries", ["creator_id"], name: "index_published_entries_on_creator_id", using: :btree
  add_index "published_entries", ["domain_id"], name: "index_published_entries_on_domain_id", using: :btree
  add_index "published_entries", ["entry_id"], name: "index_published_entries_on_entry_id", using: :btree
  add_index "published_entries", ["published_at"], name: "index_published_entries_on_published_at", using: :btree
  add_index "published_entries", ["revised_published_entry_id"], name: "index_published_entries_on_revised_published_entry_id", using: :btree

  create_table "published_entries_topics", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "published_entry_id", null: false
    t.uuid     "topic_id",           null: false
    t.integer  "order"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "published_entries_topics", ["order"], name: "index_published_entries_topics_on_order", using: :btree
  add_index "published_entries_topics", ["published_entry_id", "topic_id"], name: "index_published_entry_id_and_topic_id", unique: true, using: :btree
  add_index "published_entries_topics", ["published_entry_id"], name: "index_published_entries_topics_on_published_entry_id", using: :btree
  add_index "published_entries_topics", ["topic_id"], name: "index_published_entries_topics_on_topic_id", using: :btree

  create_table "topics", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",                                                     null: false
    t.text     "description"
    t.uuid     "menu_group_id",                                            null: false
    t.integer  "order"
    t.text     "published_entry_ordering", default: ["published_at:desc"],              array: true
    t.uuid     "creator_id",                                               null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "topics", ["creator_id"], name: "index_topics_on_creator_id", using: :btree
  add_index "topics", ["menu_group_id"], name: "index_topics_on_menu_group_id", using: :btree
  add_index "topics", ["order"], name: "index_topics_on_order", using: :btree
  add_index "topics", ["text", "menu_group_id"], name: "index_topics_on_text_and_menu_group_id", unique: true, using: :btree
  add_index "topics", ["text"], name: "index_topics_on_text", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email",                          null: false
    t.string   "encrypted_password", limit: 128, null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128, null: false
    t.datetime "locked_at"
    t.inet     "last_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.string   "user_type"
    t.uuid     "person_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
