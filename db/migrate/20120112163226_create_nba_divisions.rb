class CreateNbaDivisions < ActiveRecord::Migration
  def self.up
    create_table :nba_divisions do |t|
      t.string :name
      t.references :nba_conference

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_divisions
  end
end
