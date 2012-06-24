class CreateNbaGameScores < ActiveRecord::Migration
  def self.up
    create_table :nba_game_scores do |t|
      t.references :nba_game
      t.integer :away_first_q
      t.integer :away_second_q
      t.integer :away_third_q
      t.integer :away_fourth_q
      t.integer :away_overtime
      t.integer :home_first_q
      t.integer :home_second_q
      t.integer :home_third_q
      t.integer :home_fourth_q
      t.integer :home_overtime

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_game_scores
  end
end
