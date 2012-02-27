class EspnGameTeamStats

  def initialize(data)
    # data is the row from the stats table on an espn game page
    #
    # <tr class=even align=right>
	  # <td style="text-align:left;">FG Made-Attempted</td>
	  # <td>35-75 (.467)</td>
	  # <td>32-81 (.395)</td>
	  #</tr>
    # 
    @data = data 
  end

  def parse_stats
    game_stats = {}
    stat_type = parse_stat_type
    parse_home_stats(game_stats, stat_type)
    parse_away_stats(game_stats, stat_type)
    return game_stats
    
  end

  private 
    def parse_stat_type
      @data.search("//td")[0].inner_html.downcase
    end

    def parse_away_stats(stats, stat_type)    
      away_data = @data.search("//td")[1].inner_html
      if(away_data.split(' ').length > 1)
        stats["away #{stat_type}"] = away_data.split(' ')[0].to_i
      else
        stats["away #{stat_type}"] = away_data.to_i
      end

    end
    
    def parse_home_stats(stats, stat_type)    
      home_data = @data.search("//td")[2].inner_html
      if(home_data.split(' ').length > 1)
        stats["home #{stat_type}"] = home_data.split(' ')[0].to_i
      else
        stats["home #{stat_type}"] = home_data.to_i
      end
    end

end

