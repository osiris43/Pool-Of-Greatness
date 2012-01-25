class NbaStatImportError < ActiveRecord::Base
  belongs_to :nba_team
  belongs_to :nba_game
end
