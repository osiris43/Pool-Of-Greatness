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

ActiveRecord::Schema.define(:version => 20120422005357) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "betting_windows", :force => true do |t|
    t.integer  "kentucky_derby_pool_id"
    t.datetime "open"
    t.datetime "close"
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
    t.integer  "favorite_score", :default => 0
    t.integer  "underdog_score", :default => 0
  end

  create_table "confidence_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "season"
    t.float    "tiebreaker"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pool_id"
  end

  create_table "confidence_picks", :force => true do |t|
    t.integer  "bowl_id"
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pool_id"
    t.integer  "confidence_entry_id"
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

  create_table "golf_wager_pools_users", :id => false, :force => true do |t|
    t.integer "golf_wager_pool_id"
    t.integer "user_id"
  end

  add_index "golf_wager_pools_users", ["golf_wager_pool_id", "user_id"], :name => "index_golf_wager_pools_users_on_golf_wager_pool_id_and_user_id"

  create_table "horses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kentucky_derby_id"
    t.integer  "opening_odds"
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

  create_table "kentucky_derbies", :force => true do |t|
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kentucky_derbies_kentucky_derby_pools", :id => false, :force => true do |t|
    t.integer "kentucky_derby_id"
    t.integer "kentucky_derby_pool_id"
  end

  add_index "kentucky_derbies_kentucky_derby_pools", ["kentucky_derby_id", "kentucky_derby_pool_id"], :name => "index_on_derby_derby_pool"

  create_table "masters_entry_players", :force => true do |t|
    t.integer  "masters_pool_entry_id"
    t.integer  "masters_qualifiers_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "masters_pool_entries", :force => true do |t|
    t.integer  "masters_pool_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "masters_pools", :force => true do |t|
    t.integer  "golf_wager_pool_id"
    t.integer  "masters_tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "masters_qualifiers", :force => true do |t|
    t.integer  "pga_player_id"
    t.integer  "masters_tournament_id"
    t.integer  "wager_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "masters_tournaments", :force => true do |t|
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "importfile_file_name"
    t.string   "importfile_content_type"
    t.string   "importfile_file_size"
  end

  create_table "nba_conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nba_divisions", :force => true do |t|
    t.string   "name"
    t.integer  "nba_conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nba_game_player_stats", :force => true do |t|
    t.integer  "nba_game_id"
    t.integer  "nba_player_id"
    t.integer  "minutes"
    t.integer  "seconds"
    t.integer  "FGM"
    t.integer  "FGA"
    t.integer  "threePM"
    t.integer  "threePA"
    t.integer  "FTM"
    t.integer  "FTA"
    t.integer  "ORB"
    t.integer  "DRB"
    t.integer  "assists"
    t.integer  "fouls"
    t.integer  "steals"
    t.integer  "turnovers"
    t.integer  "blocks"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nba_team_id"
  end

  create_table "nba_game_team_stats", :force => true do |t|
    t.integer  "nba_game_id"
    t.integer  "nba_team_id"
    t.integer  "FGM"
    t.integer  "FGA"
    t.integer  "threePM"
    t.integer  "threePA"
    t.integer  "FTM"
    t.integer  "FTA"
    t.integer  "ORB"
    t.integer  "TRB"
    t.integer  "assists"
    t.integer  "turnovers"
    t.integer  "steals"
    t.integer  "blocks"
    t.integer  "fast_break_points"
    t.integer  "fouls"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "minutes"
  end

  create_table "nba_games", :force => true do |t|
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.date     "gamedate"
    t.time     "gametime"
    t.string   "season"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nba_players", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "nba_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position"
    t.string   "player_url"
  end

  create_table "nba_stat_import_errors", :force => true do |t|
    t.string   "href"
    t.integer  "nba_team_id"
    t.string   "player_name"
    t.integer  "nba_game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nba_teams", :force => true do |t|
    t.string   "city"
    t.string   "mascot"
    t.string   "abbreviation"
    t.integer  "nba_division_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pga_players", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "admin_id"
    t.string   "name"
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
