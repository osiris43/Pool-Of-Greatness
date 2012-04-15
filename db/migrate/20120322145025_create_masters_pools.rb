class CreateMastersPools < ActiveRecord::Migration
  def self.up
    create_table :masters_pools do |t|
      t.integer :golf_wager_pool_id
      t.references :masters_tournament
      t.timestamps
    end
  end

  def self.down
    drop_table :masters_pools
  end
end
