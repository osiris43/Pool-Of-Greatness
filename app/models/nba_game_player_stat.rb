class NbaGamePlayerStat < ActiveRecord::Base
  attr_accessible :nba_game_id, :minutes, :seconds, :FGM, :FGA, :threePM, :threePA,
    :FTM, :FTA, :ORB, :DRB, :assists, :fouls, :steals, :turnovers, :blocks, :points
  belongs_to :nba_game
  belongs_to :nba_player

end
