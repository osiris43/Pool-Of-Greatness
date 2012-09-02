class SetDefaultTransactionSeason < ActiveRecord::Migration
  def self.up
    Transaction.reset_column_information
    Transaction.all.each do |transaction|
      puts 'test'
      transaction.update_attributes!(:season => "2011-2012")
    end
  end

  def self.down
  end
end
