class AddPlayerUrlToNbaPlayer < ActiveRecord::Migration
  def self.up
    add_column :nba_players, :player_url, :string
  end

  def self.down
    remove_column :nba_players, :player_url
  end
end
