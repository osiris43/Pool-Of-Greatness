class FixWeek17Dates < ActiveRecord::Migration
  def self.up
    Game.reset_column_information
    Game.where(:week => 17).all.each do |game|
      d = game.gamedate.advance(:years => 1)
      game.update_attributes!(:gamedate => d)
    end
  end

  def self.down
  end
end
