class CreatePickemWeeks < ActiveRecord::Migration
  def self.up
    create_table :pickem_weeks do |t|
      t.references :pool
      t.string :season
      t.integer :week
      t.datetime :deadline

      t.timestamps
    end
  end

  def self.down
    drop_table :pickem_weeks
  end
end
