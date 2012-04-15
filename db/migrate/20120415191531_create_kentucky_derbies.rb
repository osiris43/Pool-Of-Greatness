class CreateKentuckyDerbies < ActiveRecord::Migration
  def self.up
    create_table :kentucky_derbies do |t|
      t.string :year

      t.timestamps
    end
  end

  def self.down
    drop_table :kentucky_derbies
  end
end
