class CreateOscarEntries < ActiveRecord::Migration
  def self.up
    create_table :oscar_entries do |t|
      t.references :user
      t.references :pool
      t.string :year

      t.timestamps
    end
  end

  def self.down
    drop_table :oscar_entries
  end
end
