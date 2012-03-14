class AddNbaTeamToNbaGamePlayerStats < ActiveRecord::Migration
  def self.up
    change_table :nba_game_player_stats do |t|
      t.references :nba_team
    end

    NbaGamePlayerStat.reset_column_information
    NbaGamePlayerStat.all.each do |stat|
      stat.update_attributes!(:nba_team_id => stat.nba_player.nba_team.id)
    end
    
  end

  def self.down
    remove_column :nba_game_player_stats, :nba_team_id
  end
end
