class AddKentuckyDerbyToHorse < ActiveRecord::Migration
  def self.up
    change_table :horses do |t|
      t.references :kentucky_derby 
    end 
  end

  def self.down
    remove_column :horses, :kentucky_derby_id
  end
end
