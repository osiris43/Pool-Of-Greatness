class CreatePickemEntryResults < ActiveRecord::Migration
  def self.up
    create_table :pickem_entry_results do |t|
      t.references :pickem_week_entry
      t.integer :won
      t.integer :lost
      t.integer :tied
      t.integer :place

      t.timestamps
    end
  end

  def self.down
    drop_table :pickem_entry_results
  end
end
