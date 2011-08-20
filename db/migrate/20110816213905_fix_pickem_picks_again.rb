class FixPickemPicksAgain < ActiveRecord::Migration
  def self.up
    change_table :pickem_picks do |t|
      t.remove :pickem_week_entries_id
      t.references :pickem_week_entry
    end

  end

  def self.down
  end
end
