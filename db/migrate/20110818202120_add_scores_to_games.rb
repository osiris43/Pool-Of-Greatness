class AddScoresToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :awayscore, :integer, :default => 0
    add_column :games, :homescore, :integer, :default => 0
  end

  def self.down
    remove_column :games, :homescore
    remove_column :games, :awayscore
  end
end
