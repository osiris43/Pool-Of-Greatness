class AddPositionToNbaPlayer < ActiveRecord::Migration
  def self.up
    add_column :nba_players, :position, :string
  end

  def self.down
    remove_column :nba_players, :position
  end
end
