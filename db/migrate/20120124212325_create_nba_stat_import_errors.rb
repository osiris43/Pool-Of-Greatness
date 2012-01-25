class CreateNbaStatImportErrors < ActiveRecord::Migration
  def self.up
    create_table :nba_stat_import_errors do |t|
      t.string :href
      t.references :nba_team
      t.string :player_name
      t.references :nba_game

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_stat_import_errors
  end
end
