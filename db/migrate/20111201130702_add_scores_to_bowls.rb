class AddScoresToBowls < ActiveRecord::Migration
  def self.up
    add_column :bowls, :favorite_score, :int, :default => 0
    add_column :bowls, :underdog_score, :int, :default => 0
  end

  def self.down
    remove_column :bowls, :underdog_score
    remove_column :bowls, :favorite_score
  end
end
