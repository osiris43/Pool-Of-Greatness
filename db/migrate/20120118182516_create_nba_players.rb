class CreateNbaPlayers < ActiveRecord::Migration
  def self.up
    create_table :nba_players do |t|
      t.string :firstname
      t.string :lastname
      t.references :nba_team

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_players
  end
end
