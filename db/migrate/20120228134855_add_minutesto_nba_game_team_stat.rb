class AddMinutestoNbaGameTeamStat < ActiveRecord::Migration
  def self.up
    add_column :nba_game_team_stats, :minutes, :integer
  end

  def self.down
  end
end
