class EspnGameFieldgoals

  def initialize(fieldgoal_data)
    # fieldgoal_data is the row from the stats table on an espn game page
    # the row is the field goals row and looks like this
    #
    # <tr class=even align=right>
	  # <td style="text-align:left;">FG Made-Attempted</td>
	  # <td>35-75 (.467)</td>
	  # <td>32-81 (.395)</td>
	  #</tr>
    # 
    @data = fieldgoal_data
  end

  def parse_stats 
    game_stats = {}
    parse_home_fg(game_stats)
    parse_away_fg(game_stats)
    return game_stats
  end

  private
    def parse_home_fg(stats)
      home_data = @data.search("//td")[2].inner_html
      stats["home_fg_made"] = home_data.split(' ')[0].split('-')[0].to_i
      stats["home_fg_attempted"] = home_data.split(' ')[0].split('-')[1].to_i
    end

    def parse_away_fg(stats)    
      away_data = @data.search("//td")[1].inner_html
      stats["away_fg_attempted"] = away_data.split(' ')[0].split('-')[1].to_i
      stats["away_fg_made"] = away_data.split(' ')[0].split('-')[0].to_i
    end
end
