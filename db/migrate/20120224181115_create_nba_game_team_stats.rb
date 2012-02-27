class CreateNbaGameTeamStats < ActiveRecord::Migration
  def self.up
    create_table :nba_game_team_stats do |t|
      t.references :nba_game
      t.references :nba_team
      t.integer :FGM
      t.integer :FGA
      t.integer :threePM
      t.integer :threePA
      t.integer :FTM
      t.integer :FTA
      t.integer :ORB
      t.integer :TRB
      t.integer :assists
      t.integer :turnovers
      t.integer :steals
      t.integer :blocks
      t.integer :fast_break_points
      t.integer :fouls

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_game_team_stats
  end
end
