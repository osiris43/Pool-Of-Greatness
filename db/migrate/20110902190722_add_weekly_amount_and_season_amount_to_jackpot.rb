class AddWeeklyAmountAndSeasonAmountToJackpot < ActiveRecord::Migration
  def self.up
    add_column :jackpots, :weeklyamount, :integer
    add_column :jackpots, :seasonamount, :integer
  end

  def self.down
    remove_column :jackpots, :seasonamount
    remove_column :jackpots, :weeklyamount
  end
end
