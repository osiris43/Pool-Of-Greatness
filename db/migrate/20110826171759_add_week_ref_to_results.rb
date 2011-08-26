class AddWeekRefToResults < ActiveRecord::Migration
  def self.up
    change_table :pickem_entry_results do |t|
      t.references :pickem_week 
    end
  end

  def self.down
  end
end
