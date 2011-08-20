class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.references :account
      t.string :pooltype
      t.string :poolname
      t.float :amount
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
