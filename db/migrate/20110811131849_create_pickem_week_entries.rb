class CreatePickemWeekEntries < ActiveRecord::Migration
  def self.up
    create_table :pickem_week_entries do |t|
      t.references :user
      t.references :pickem_week
      t.float :mondaynighttotal

      t.timestamps
    end
  end

  def self.down
    drop_table :pickem_week_entries
  end
end
