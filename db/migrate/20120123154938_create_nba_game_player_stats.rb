class CreateNbaGamePlayerStats < ActiveRecord::Migration
  def self.up
    create_table :nba_game_player_stats do |t|
      t.references :nba_game
      t.references :nba_player
      t.integer :minutes
      t.integer :seconds
      t.integer :FGM
      t.integer :FGA
      t.integer :threePM
      t.integer :threePA
      t.integer :FTM
      t.integer :FTA
      t.integer :ORB
      t.integer :DRB
      t.integer :assists
      t.integer :fouls
      t.integer :steals
      t.integer :turnovers
      t.integer :blocks
      t.integer :points

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_game_player_stats
  end
end
