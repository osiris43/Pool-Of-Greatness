class SurvivorEntry < ActiveRecord::Base
  attr_accessible :game, :team, :week, :season, :survivor_session

  belongs_to :user, :counter_cache => true
  belongs_to :game
  belongs_to :team
  belongs_to :survivor_session 

  default_scope :order => "survivor_entries.week"

  def result
    if game.awayscore == 0 && game.homescore == 0
      "NotScored"
    elsif game.winning_team == team
      "Win"
    else
      "Loss"
    end
  end
end
