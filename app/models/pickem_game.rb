class PickemGame < ActiveRecord::Base
  attr_accessible :game_id, :pickem_week_id, :istiebreaker 
  belongs_to :pickem_week
  belongs_to :game

  default_scope :joins => :game, :order => 'games.gamedate, games.id'
end
