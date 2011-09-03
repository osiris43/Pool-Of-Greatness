require 'date'

Factory.define :user do |user|
  user.username               "testusername"
  user.email                  "test@test.com"
  user.password               "password"
  user.password_confirmation  "password"
  user.admin                  false
  user.name                   "Brett Bim"
end

Factory.define :pool_template do |pool_template|
  pool_template.name        "Pick em"
  pool_template.description "A weekly pick 'em pool"  
end

Factory.define :pickem_pool do |pickempool|
  pickempool.name         "My Pool"
  pickempool.type         "PickemPool"
end

Factory.define :survivor_pool do |survivorpool|
  survivorpool.name         "My Survivor Pool"
  survivorpool.type         "SurvivorPool"
  survivorpool.admin_id     1
end

Factory.define :pool_config do |poolconfig|
  poolconfig.config_key     "mykey"
  poolconfig.config_value   "myvalue"
  poolconfig.association    :pool
end

Factory.define :pickem_week do |pickemweek|
  pickemweek.season       "2011-2012"
  pickemweek.week         1
  pickemweek.deadline     DateTime.now + 7
  pickemweek.association  :pickem_pool
end

Factory.define :team do |team|
  team.teamname   "Dallas Cowboys"
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
  game.season     "2011-2012"
  game.week       1
  game.away_team  :away_team
  game.home_team  :home_team
  game.line       -2
  game.gamedate   DateTime.now + 1
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

Factory.define :pickem_pick do |factory|

  factory.association :game 
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



