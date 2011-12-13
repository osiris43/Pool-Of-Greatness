class CreateConfidenceEntries < ActiveRecord::Migration
  def self.up
    create_table :confidence_entries do |t|
      t.references :user
      t.integer :season
      t.float :tiebreaker

      t.timestamps
    end
  end

  def self.down
    drop_table :confidence_entries
  end
end
