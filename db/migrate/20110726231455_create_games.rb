class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :away_team
      t.integer :home_team
      t.float :line
      t.float :overunder
      t.datetime :gamedate
      t.string :season
      t.integer :week
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
