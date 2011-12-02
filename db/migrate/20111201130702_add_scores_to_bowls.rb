class AddScoresToBowls < ActiveRecord::Migration
  def self.up
    add_column :bowls, :favorite_score, :int
    add_column :bowls, :underdog_score, :int
  end

  def self.down
    remove_column :bowls, :underdog_score
    remove_column :bowls, :favorite_score
  end
end
