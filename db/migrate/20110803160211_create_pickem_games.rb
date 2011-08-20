class CreatePickemGames < ActiveRecord::Migration
  def self.up
    create_table :pickem_games do |t|
      t.references :pickem_week
      t.references :game

      t.timestamps
    end
  end

  def self.down
    drop_table :pickem_games
  end
end
