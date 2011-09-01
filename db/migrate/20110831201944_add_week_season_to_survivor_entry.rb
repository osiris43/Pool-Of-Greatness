class AddWeekSeasonToSurvivorEntry < ActiveRecord::Migration
  def self.up
    add_column :survivor_entries, :week, :integer
    add_column :survivor_entries, :season, :string
  end

  def self.down
    remove_column :survivor_entries, :season
    remove_column :survivor_entries, :week
  end
end
