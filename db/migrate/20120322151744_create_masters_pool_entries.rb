class CreateMastersPoolEntries < ActiveRecord::Migration
  def self.up
    create_table :masters_pool_entries do |t|
      t.references :masters_pool
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :masters_pool_entries
  end
end
