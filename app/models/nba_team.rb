class NbaTeam < ActiveRecord::Base
  belongs_to :nba_division
  has_many :nba_players
end
