class CreateNbaTeams < ActiveRecord::Migration
  def self.up
    create_table :nba_teams do |t|
      t.string :city
      t.string :mascot
      t.string :abbreviation
      t.references :nba_division

      t.timestamps
    end
  end

  def self.down
    drop_table :nba_teams
  end
end
