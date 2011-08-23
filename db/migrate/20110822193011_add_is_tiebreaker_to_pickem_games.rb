class AddIsTiebreakerToPickemGames < ActiveRecord::Migration
  def self.up
    add_column :pickem_games, :istiebreaker, :boolean
  end

  def self.down
    remove_column :pickem_games, :istiebreaker
  end
end
