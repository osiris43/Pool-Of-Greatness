class FixPickemPicks < ActiveRecord::Migration
  def self.up
    change_table :pickem_picks do |t|
      t.references :pickem_week_entries
      t.remove :user_id
      t.remove :pickem_week_id
    end
  end

  def self.down
  end
end
