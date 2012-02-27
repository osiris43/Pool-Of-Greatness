class EspnGameThrees

  def initialize(three_data)
    # field_data is the row from the stats table on an espn game page
    # the row is the threes row and looks like this
    #
    # <tr class=even align=right>
	  # <td style="text-align:left;">FG Made-Attempted</td>
	  # <td>35-75 (.467)</td>
	  # <td>32-81 (.395)</td>
	  #</tr>
    # 
    @data = three_data
  end

  def parse_stats
    game_stats = {}
    parse_home_3p(game_stats)
    parse_away_3p(game_stats)
    return game_stats
    
  end

  private 
    def parse_away_3p(stats)    
      away_data = @data.search("//td")[1].inner_html
      stats["away_3p_attempted"] = away_data.split(' ')[0].split('-')[1].to_i
      stats["away_3p_made"] = away_data.split(' ')[0].split('-')[0].to_i
    end
    
    def parse_home_3p(stats)    
      home_data = @data.search("//td")[2].inner_html
      stats["home_3p_attempted"] = home_data.split(' ')[0].split('-')[1].to_i
      stats["home_3p_made"] = home_data.split(' ')[0].split('-')[0].to_i
    end

end

