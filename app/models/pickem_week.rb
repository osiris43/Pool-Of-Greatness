class PickemWeek < ActiveRecord::Base
  attr_accessible :season, :week, :deadline

  belongs_to :pickem_pool
  has_many :pickem_games
  has_many :pickem_week_entries

  validates :season, :presence => true
  validates_numericality_of :week, :greater_than => 0

  def save_picks(selectedGames, current_user, mnfTotal)
    entry = pickem_week_entries.create!(:user => current_user, :mondaynighttotal => mnfTotal)
    selectedGames.each {|key, value| save_pick(key, value, current_user, entry)} 
  end

  private
    def save_pick(gamekey, teamid, current_user, entry)
      # gamekey looks like gameid_xxx where xxx is the game id
      entry.pickem_picks.create!(:game_id => gamekey[7..-1].to_i, :team_id => teamid.to_i)
    end
end
