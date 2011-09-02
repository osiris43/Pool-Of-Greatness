class CreateJackpots < ActiveRecord::Migration
  def self.up
    create_table :jackpots do |t|
      t.references :pool
      t.integer :weeklyjackpot
      t.integer :seasonjackpot

      t.timestamps
    end
  end

  def self.down
    drop_table :jackpots
  end
end
