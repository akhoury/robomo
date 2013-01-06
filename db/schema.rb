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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130106143459) do

  create_table "assets", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "post_id"
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
  end

  create_table "cc_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "duplications", :force => true do |t|
    t.integer "ticket_id"
    t.integer "duplicate_id"
  end

  create_table "exclusive_withs", :force => true do |t|
    t.integer "ticket_id"
    t.integer "exclusion_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "ticket_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  add_index "posts", ["ticket_id"], :name => "index_posts_on_ticket_id"

  create_table "state_changes", :force => true do |t|
    t.string   "state",      :null => false
    t.datetime "changed_at"
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "ticket_links", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "linked_ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "summary",                        :limit => 1500
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.string   "state",                                          :default => "pending"
    t.datetime "last_post_at"
    t.integer  "last_modified_by"
    t.integer  "posts_count",                                    :default => 0
    t.integer  "time_to_first_reply_in_seconds"
    t.string   "sprint_tag"
    t.integer  "readiness"
    t.integer  "importance"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "receive_all_emails", :default => false
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
