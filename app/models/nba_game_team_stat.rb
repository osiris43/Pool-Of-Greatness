class NbaGameTeamStat < ActiveRecord::Base
  belongs_to :nba_game
  belongs_to :nba_team
end
