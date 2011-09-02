class AddAbbreviationToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :abbreviation, :string 
  end

  def self.down
  end
end
