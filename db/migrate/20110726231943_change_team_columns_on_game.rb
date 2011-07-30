class ChangeTeamColumnsOnGame < ActiveRecord::Migration
  def self.up
    change_table :games do |t|
      t.rename :away_team, :away_team_id
      t.rename :home_team, :home_team_id
    end
  end

  def self.down
  end
end
