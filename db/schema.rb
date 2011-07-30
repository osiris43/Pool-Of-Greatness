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

ActiveRecord::Schema.define(:version => 20110728172546) do

  create_table "games", :force => true do |t|
    t.integer  "away_team_id"
    t.integer  "home_team_id"
    t.float    "line"
    t.float    "overunder"
    t.datetime "gamedate"
    t.string   "season"
    t.integer  "week"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pickem_weeks", :force => true do |t|
    t.integer  "pool_id"
    t.string   "season"
    t.integer  "week"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pool_configs", :force => true do |t|
    t.integer  "pool_id"
    t.string   "config_key"
    t.string   "config_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pool_templates", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pools", :force => true do |t|
    t.string   "name"
    t.integer  "pool_template_id"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pools", ["name"], :name => "index_pools_on_name", :unique => true

  create_table "poolusers", :force => true do |t|
    t.integer  "pool_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "city"
    t.string   "mascot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

end
