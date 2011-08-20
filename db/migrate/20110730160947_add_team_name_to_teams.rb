class AddTeamNameToTeams < ActiveRecord::Migration
  def self.up
    change_table :teams do |t|
      t.string :teamname
    end
  end

  def self.down
  end
end
