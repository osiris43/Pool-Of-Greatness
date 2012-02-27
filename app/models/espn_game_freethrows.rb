class EspnGameFreethrows

  def initialize(freethrow_data)
    # freethrow_data is the row from the stats table on an espn game page
    # the row is the free throws row and looks like this
    #
    # <tr class=even align=right>
	  # <td style="text-align:left;">FG Made-Attempted</td>
	  # <td>35-75 (.467)</td>
	  # <td>32-81 (.395)</td>
	  #</tr>
    # 
    @data = freethrow_data 
  end

  def parse_stats
    game_stats = {}
    parse_home_ft(game_stats)
    parse_away_ft(game_stats)
    return game_stats
    
  end

  private 
    def parse_away_ft(stats)    
      away_data = @data.search("//td")[1].inner_html
      stats["away_ft_attempted"] = away_data.split(' ')[0].split('-')[1].to_i
      stats["away_ft_made"] = away_data.split(' ')[0].split('-')[0].to_i
    end
    
    def parse_home_ft(stats)    
      home_data = @data.search("//td")[2].inner_html
      stats["home_ft_attempted"] = home_data.split(' ')[0].split('-')[1].to_i
      stats["home_ft_made"] = home_data.split(' ')[0].split('-')[0].to_i
    end

end

