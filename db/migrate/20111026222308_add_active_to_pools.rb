class AddActiveToPools < ActiveRecord::Migration
  def self.up
    add_column :pools, :active, :boolean, :default => true
    Pool.update_all ["active = ?", true]
  end

  def self.down
    remove_column :pools, :active
  end
end
