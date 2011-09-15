class AddCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :survivor_entries_count, :integer, :default => 0

    User.reset_column_information
    User.find(:all).each do |u|
      User.update_counters u.id, :survivor_entries_count => u.survivor_entries.length
    end
  end

  def self.down
    remove_column :users, :survivor_entries_count
  end
end
