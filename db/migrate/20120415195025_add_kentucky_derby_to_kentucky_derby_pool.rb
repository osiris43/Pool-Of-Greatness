class AddKentuckyDerbyToKentuckyDerbyPool < ActiveRecord::Migration
  def self.up
    create_table :kentucky_derbies_kentucky_derby_pools, :id => false do |t|
      t.references :kentucky_derby, :kentucky_derby_pool
    end

    add_index :kentucky_derbies_kentucky_derby_pools, [:kentucky_derby_id, :kentucky_derby_pool_id], :name => "index_on_derby_derby_pool"
  end

  def self.down
    drop_table :kentucky_derbies_kentucky_derby_pools
  end
end
