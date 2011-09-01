class SurvivorEntry < ActiveRecord::Base
  attr_accessible :game, :team, :week, :season

  belongs_to :user
  belongs_to :game
  belongs_to :team

  default_scope :order => "survivor_entries.week"

  def result
    if game.awayscore == 0 && game.homescore == 0
      "Not Scored yet"
    elsif game.winning_team == team
      "Win"
    else
      "Loss"
    end
  end
end
