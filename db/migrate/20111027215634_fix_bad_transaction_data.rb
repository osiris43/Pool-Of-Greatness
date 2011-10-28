class FixBadTransactionData < ActiveRecord::Migration
  def self.up
    Transaction.reset_column_information
    Transaction.where(:pool_id => 0).all.each do |transaction|
      p = Pool.find_by_name(transaction.poolname)
      transaction.update_attributes(:pool_id => p.id)
    end
  end

  def self.down
  end
end
