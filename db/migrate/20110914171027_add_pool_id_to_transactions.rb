class AddPoolIdToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :pool_id, :integer, :default => 0

    Transaction.reset_column_information
    Transaction.all.each do |t|
      pool = Pool.find_by_name(t.poolname)
      t.update_attributes! :pool_id => pool.id
    end
  end

  def self.down
    remove_column :transactions, :pool_id
  end
end
