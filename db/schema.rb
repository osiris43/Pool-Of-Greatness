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

ActiveRecord::Schema.define(:version => 20111129210324) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bowls", :force => true do |t|
    t.datetime "date"
    t.string   "season"
    t.string   "name"
    t.string   "site"
    t.float    "line"
    t.integer  "favorite_id"
    t.integer  "underdog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "confidence_picks", :force => true do |t|
    t.integer  "bowl_id"
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "awayscore",    :default => 0
    t.integer  "homescore",    :default => 0
  end

  create_table "jackpots", :force => true do |t|
    t.integer  "pool_id"
    t.integer  "weeklyjackpot"
    t.integer  "seasonjackpot"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weeklyamount"
    t.integer  "seasonamount"
  end

  create_table "pickem_entry_results", :force => true do |t|
    t.integer  "pickem_week_entry_id"
    t.integer  "won"
    t.integer  "lost"
    t.integer  "tied"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "tiebreak_distance"
    t.integer  "pickem_week_id"
  end

  create_table "pickem_games", :force => true do |t|
    t.integer  "pickem_week_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "istiebreaker"
  end

  create_table "pickem_picks", :force => true do |t|
    t.integer  "game_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pickem_week_entry_id"
  end

  create_table "pickem_pools", :force => true do |t|
    t.string   "name"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pickem_pools", ["name"], :name => "index_pools_on_name", :unique => true

  create_table "pickem_rules", :force => true do |t|
    t.integer  "pickem_pool_id"
    t.string   "config_key"
    t.string   "config_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pickem_week_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pickem_week_id"
    t.float    "mondaynighttotal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pickem_weeks", :force => true do |t|
    t.integer  "pickem_pool_id"
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
    t.integer  "admin_id"
    t.integer  "site_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  create_table "poolusers", :force => true do |t|
    t.integer  "pool_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "slug"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites_users", :id => false, :force => true do |t|
    t.integer "site_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "survivor_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "week"
    t.string   "season"
    t.integer  "survivor_session_id"
  end

  create_table "survivor_sessions", :force => true do |t|
    t.integer  "pool_id"
    t.integer  "starting_week"
    t.integer  "ending_week"
    t.string   "season"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "teams", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teamname"
    t.string   "abbreviation"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "account_id"
    t.string   "pooltype"
    t.string   "poolname"
    t.float    "amount"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pool_id",     :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "name"
    t.integer  "survivor_entries_count", :default => 0
  end

end
