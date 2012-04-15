class CreateBettingWindows < ActiveRecord::Migration
  def self.up
    create_table :betting_windows do |t|
      t.references :kentucky_derby_pool 
      t.datetime :open
      t.datetime :close

      t.timestamps
    end
  end

  def self.down
    drop_table :betting_windows
  end
end
