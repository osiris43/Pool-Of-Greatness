class AddNameUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :pools, :name, :unique => true
  end

  def self.down
    remove_index :pools, :name
  end
end
