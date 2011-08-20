class RenamePoolsToPickemPools < ActiveRecord::Migration
  def self.up
    rename_table :pools, :pickem_pools
  end

  def self.down
  end
end
