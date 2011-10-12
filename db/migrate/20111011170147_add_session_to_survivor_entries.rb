class AddSessionToSurvivorEntries < ActiveRecord::Migration
  def self.up
    add_column :survivor_entries, :survivor_session_id, :integer
  end

  def self.down
    remove_column :survivor_entries, :survivor_session_id
  end
end
