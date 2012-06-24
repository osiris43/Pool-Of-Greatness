class AddOpeningOddsToHorse < ActiveRecord::Migration
  def self.up
    add_column :horses, :opening_odds, :integer
  end

  def self.down
    remove_column :horses, :opening_odds
  end
end
