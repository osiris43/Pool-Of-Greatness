class CreateNbaConferences < ActiveRecord::Migration
  def self.up
    create_table :nba_conferences do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_conferences
  end
end
