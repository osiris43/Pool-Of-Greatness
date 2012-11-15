class AddPlayerUrlToNbaStatImportError < ActiveRecord::Migration
  def self.up
    add_column :nba_stat_import_errors, :playerurl, :string
  end

  def self.down
    remove_column :nba_stat_import_errors, :playerurl
  end
end
