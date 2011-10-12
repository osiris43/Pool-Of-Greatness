class CreateSurvivorSessions < ActiveRecord::Migration
  def self.up
    create_table :survivor_sessions do |t|
      t.references :pool
      t.integer :starting_week
      t.integer :ending_week
      t.string :season

      t.timestamps
    end
  end

  def self.down
    drop_table :survivor_sessions
  end
end
