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

ActiveRecord::Schema.define(:version => 20130605220000) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "categories", ["name", "user_id"], :name => "index_categories_on_name_and_user_id"

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "member_id"
  end

  add_index "hosts", ["name", "user_id"], :name => "index_hosts_on_name_and_user_id"

  create_table "hosts_members", :id => false, :force => true do |t|
    t.integer "host_id"
    t.integer "member_id"
  end

  add_index "hosts_members", ["host_id", "member_id"], :name => "index_hosts_members_on_host_id_and_member_id"

  create_table "members", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "host_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "host_id"
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string "email"
    t.string "password_digest"
  end

end
