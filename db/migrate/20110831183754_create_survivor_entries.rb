class CreateSurvivorEntries < ActiveRecord::Migration
  def self.up
    create_table :survivor_entries do |t|
      t.references :user
      t.references :game
      t.references :team

      t.timestamps
    end
  end

  def self.down
    drop_table :survivor_entries
  end
end
