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

ActiveRecord::Schema.define(version: 20170217201019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

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

  create_table "group_topic_published_entries", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "group_id",           null: false
    t.uuid     "topic_id"
    t.uuid     "published_entry_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "group_topic_published_entries", ["group_id"], name: "index_group_topic_published_entries_on_group_id", using: :btree
  add_index "group_topic_published_entries", ["published_entry_id"], name: "index_group_topic_published_entries_on_published_entry_id", using: :btree
  add_index "group_topic_published_entries", ["topic_id"], name: "index_group_topic_published_entries_on_topic_id", using: :btree

  create_table "groups", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",        null: false
    t.text     "description"
    t.uuid     "domain_id",   null: false
    t.integer  "order",       null: false
    t.string   "type",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "groups", ["domain_id", "type", "text"], name: "index_groups_on_domain_id_and_type_and_text", unique: true, using: :btree
  add_index "groups", ["domain_id"], name: "index_groups_on_domain_id", using: :btree
  add_index "groups", ["text"], name: "index_groups_on_text", using: :btree

  create_table "menus", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",        null: false
    t.text     "description"
    t.uuid     "domain_id",   null: false
    t.integer  "order",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "menus", ["domain_id"], name: "index_menus_on_domain_id", using: :btree
  add_index "menus", ["text"], name: "index_menus_on_text", using: :btree

  create_table "menus_menu_groups", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid "menu_id",       null: false
    t.uuid "menu_group_id", null: false
  end

  add_index "menus_menu_groups", ["menu_group_id"], name: "index_menus_menu_groups_on_menu_group_id", using: :btree
  add_index "menus_menu_groups", ["menu_id", "menu_group_id"], name: "index_menus_menu_groups_on_menu_id_and_menu_group_id", using: :btree
  add_index "menus_menu_groups", ["menu_id"], name: "index_menus_menu_groups_on_menu_id", using: :btree

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
    t.string   "type"
    t.json     "data"
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
  add_index "published_entries", ["revised_published_entry_id"], name: "index_published_entries_on_revised_published_entry_id", using: :btree

  create_table "topics", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "text",        null: false
    t.text     "description"
    t.uuid     "domain_id",   null: false
    t.uuid     "group_id",    null: false
    t.uuid     "creator_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "topics", ["creator_id"], name: "index_topics_on_creator_id", using: :btree
  add_index "topics", ["domain_id"], name: "index_topics_on_domain_id", using: :btree
  add_index "topics", ["group_id"], name: "index_topics_on_group_id", using: :btree
  add_index "topics", ["text", "group_id"], name: "index_topics_on_text_and_group_id", unique: true, using: :btree
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
