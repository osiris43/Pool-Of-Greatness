require 'date'
FactoryGirl.define do

  factory :nba_team do
    city      :Boston
    mascot    :Celtics
  end 

  factory :nbahome, :parent => :nba_team do
    city          'Boston'
    mascot        'Celtics'
    abbreviation  'BOS'
  end 
  
  factory :nbaaway, :parent => :nba_team do
    city          'Dallas'
    mascot        'Mavericks'
    abbreviation  'DAL'
  end 
  
  factory :nba_conference do
    name "my conference"
  end 

  factory :nba_division do
    name            "my division"
    nba_conference  :factory => :nba_conference
  end 
 
  factory :nba_player do
    firstname   "Ray"
    lastname    "Allen"
    nba_team    :factory => :nbahome
    position    "Guard"
  end 

  factory :nba_game do
    home_team     :factory => :nbahome
    away_team     :factory => :nbaaway
    score         :factory => :nba_game_score 
    season       "2011-2012"
    gamedate      Date.current
    gametime      Time.current
  end

  factory :nba_game_score do
    away_first_q    1
    away_second_q   2
    away_third_q    3
    away_fourth_q   4
    away_overtime   5
    home_first_q    6
    home_second_q   7
    home_third_q    8
    home_fourth_q   9
    home_overtime   10
  end

  factory :pickem_pool do
    sequence :name do |n|
      "My Pool #{n}"
    end
    type         "PickemPool"
    after_create { |pickempool| add_standard_config(pickempool)}
  end

  factory :confidence_pool do
    name    "Confidence"
    type    "ConfidencePool"
  end

  factory :kentucky_derby_pool do
    name "All The Pretty Horsies"
    type "KentuckyDerbyPool"
  end
  
  factory :golf_wager_pool do
    name    "Masters Pool"
    type    "GolfWagerPool"
  end

  factory :masters_pool do
    association :golf_wager_pool, :factory => :golf_wager_pool
    association :masters_tournament, :factory => :masters_tournament
  end

  factory :masters_pool_entry do
    association :masters_pool, :factory => :masters_pool
  end

  factory :pga_player do
    name  "Tiger Woods"
  end

  factory :masters_qualifier do
    association :pga_player , :factory => :pga_player
    association :masters_tournament, :factory => :masters_tournament
  end

  factory :masters_tournament do
    year  DateTime.current.year.to_s
  end

  factory :team do
    teamname  'Dallas Cowboys'
  end

  factory :sequence_team, :parent => :team do
    sequence :teamname do |n|
      "Team #{n}"
    end
  end

  factory :db_config do
    key   "CurrentSeason"
    value "2011-2012"
  end

  factory :bowl_season, :parent => :db_config do
    key   "CurrentBowlSeason"
    value "2010"
  end

  factory :nba_season, :parent => :db_config do
    key "CurrentNbaSeason"
    value "2011-2012"
  end

  factory :survivor_session do
    association :pool, :factory => :survivor_pool
    starting_week   1
    ending_week     5
    season          "2011-2012" 
  end

  factory :bowl_favorite, :parent => :team do
    teamname  "TCU Horned Frogs"
  end

  factory :bowl_underdog, :parent => :team do
    teamname  "Oklahoma Sooners"
  end

  factory :bowl do
    date            DateTime.current + 7
    season          "2010"
    name            "Test Bowl"
    site            "Dallas"
    line            -7
    favorite        :factory => :bowl_favorite
    underdog        :factory => :bowl_underdog
    after_create{|bowl| Factory(:bowl_season) }
  end

  factory :nba_stat_import_error do
    player_name     "Mo Cheeks" 
    href            "/player_file/mo_cheeks.html"
  end
end

Factory.define :user do |user|
  user.sequence(:username)    {|n| "testusername#{n}" }
  user.sequence(:email)       {|n| "test#{n}@test.com" }
  user.password               "password"
  user.password_confirmation  "password"
  user.admin                  false
  user.name                   "Brett Bim"
end

Factory.define :pool_template do |pool_template|
  pool_template.name        "Pick em"
  pool_template.description "A weekly pick 'em pool"  
end

def add_standard_config(pool)
  pool.pickem_rules.create(:config_key => "current_week", :config_value => "1") 
  pool.pickem_rules.create(:config_key => "weekly_fee", :config_value => "10") 
  pool.pickem_rules.create(:config_key => "current_season", :config_value => "2011-2012")
  pool.pickem_rules.create(:config_key => "pro", :config_value => "1")
  pool.pickem_rules.create(:config_key => "college", :config_value => "1")

end

Factory.define :survivor_pool do |survivorpool|
  survivorpool.site_id      1
  survivorpool.name         "My Survivor Pool"
  survivorpool.type         "SurvivorPool"
  survivorpool.admin_id     1
end

Factory.define :pool_config do |poolconfig|
  poolconfig.config_key     :config_key
  poolconfig.config_value   :config_value
  poolconfig.association    :pool
end

Factory.define :pickem_week do |pickemweek|
  pickemweek.season       "2011-2012"
  pickemweek.week         1
  pickemweek.deadline     DateTime.now + 7
  pickemweek.association  :pickem_pool
end

Factory.define :nflhometeam, :parent => :team do |team|
  team.teamname       "Dallas Cowboys"
  team.abbreviation   "DAL"
end

Factory.define :nflawayteam, :parent => :team do |team|
  team.teamname       "New York Jets"
  team.abbreviation   "NYJ"
end

Factory.define :nflgame do |game|
  game.season       "2011-2012"
  game.week         1
  game.association  :away_team, :factory => :nflawayteam
  game.association  :home_team, :factory => :nflhometeam
  game.line         -2
  game.gamedate     DateTime.now + 1
  game.awayscore    20
  game.homescore    23
end

Factory.define :sequence_game, :parent => :nflgame do |game|
  game.season       "2011-2012"
  game.week         1
  game.association  :away_team, :factory => :sequence_team
  game.association  :home_team, :factory => :sequence_team
  game.line         -2
  game.gamedate     DateTime.now + 1
  game.awayscore    20
  game.homescore    23
end

Factory.define :ncaagame do |game|
  game.season     "2011-2012"
  game.week       1
  game.away_team  :away_team
  game.home_team  :home_team
  game.line       -2
  game.gamedate   DateTime.now + 1
end

Factory.define :pickem_rule do |rule|
  rule.config_key     "mykey"
  rule.config_value   "myvalue"
  rule.association    :pickem_pool
end

Factory.define :pickem_week_entry do |entry|
  entry.association       :user
  entry.association       :pickem_week
  entry.mondaynighttotal  45
end

Factory.define :pickem_pick do |factory|
  factory.association :team, :factory => :nflawayteam
  factory.association :game, :factory => :nflgame 
  factory.association :pickem_week_entry
end

Factory.define :pickem_pick_with_favorite, :parent => :pickem_pick do |factory|
  factory.association :team, :factory => :nflhometeam
  factory.association :game, :factory => :nflgame 
  factory.association :pickem_week_entry
end

Factory.define :pickem_pick_with_game_seq, :parent => :pickem_pick do |factory|
  factory.association :team, :factory => :nflhometeam
  factory.association :game, :factory => :sequence_game
  factory.association :pickem_week_entry
end

Factory.define :pickem_game do |factory|

end

Factory.define :pickem_entry_result do |result|
  result.pickem_week_entry_id   1
  result.won                    10
  result.lost                   7
  result.tied                   0
  result.tiebreak_distance      10
end



