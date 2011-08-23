class DropPlaceFromPickemEntryResult < ActiveRecord::Migration
  def self.up
    change_table :pickem_entry_results do |t|
      t.remove :place
      t.float :tiebreak_distance
    end
  end

  def self.down
  end
end
