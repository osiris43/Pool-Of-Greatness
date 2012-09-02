class AddSeasonToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :season, :string

  end

  def self.down
    remove_column :transactions, :season
  end
end
