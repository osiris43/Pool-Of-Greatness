class CreatePickemPicks < ActiveRecord::Migration
  def self.up
    create_table :pickem_picks do |t|
      t.references :game
      t.references :team
      t.references :user
      t.references :pickem_week
      t.timestamps
    end
  end

  def self.down
    drop_table :pickem_picks
  end
end
