class CreateNbaGames < ActiveRecord::Migration
  def self.up
    create_table :nba_games do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.date :gamedate
      t.time :gametime
      t.string :season

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_games
  end
end
