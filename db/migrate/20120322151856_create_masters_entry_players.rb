class CreateMastersEntryPlayers < ActiveRecord::Migration
  def self.up
    create_table :masters_entry_players do |t|
      t.references :masters_pool_entry
      t.references :masters_qualifiers

      t.timestamps
    end
  end

  def self.down
    drop_table :masters_entry_players
  end
end
