require 'date'

Factory.define :user do |user|
  user.username               "testusername"
  user.email                  "test@test.com"
  user.password               "password"
  user.password_confirmation  "password"
  user.admin                  false
end

Factory.define :pool_template do |pool_template|
  pool_template.name        "Pick em"
  pool_template.description "A weekly pick 'em pool"  
end

Factory.define :pool do |pool|
  pool.name         "My Pool"
  pool.association  :pool_template
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
  pickemweek.association  :pool
end

Factory.define :team do |team|
  team.city     "Dallas"
  team.mascot   "Cowboys"
end

Factory.define :nflgame do |game|
  game.season     "2011-2012"
  game.week       1
  game.away_team  :away_team
  game.home_team  :home_team
  game.line       -2
end


