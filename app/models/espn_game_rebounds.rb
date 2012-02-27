class EspnGameRebounds

  def initialize(rebound_data)
    # rebound_data is the row from the stats table on an espn game page
    # the row is the rebounds row and looks like this
    #
    # <tr class=even align=right>
	  # <td style="text-align:left;">FG Made-Attempted</td>
	  # <td>35-75</td>
	  # <td>32-81</td>
	  #</tr>
    # 
    @data = rebound_data 
  end

  def parse_stats
    game_stats = {}
    parse_home_rebounds(game_stats)
    parse_away_rebounds(game_stats)
    return game_stats
    
  end

  private 
    def parse_away_rebounds(stats)    
      away_data = @data.search("//td")[1].inner_html
      stats["away_trb"] = away_data.split(' ')[0].split('-')[1].to_i
      stats["away_orb"] = away_data.split(' ')[0].split('-')[0].to_i
    end
    
    def parse_home_rebounds(stats)    
      home_data = @data.search("//td")[2].inner_html
      stats["home_trb"] = home_data.split(' ')[0].split('-')[1].to_i
      stats["home_orb"] = home_data.split(' ')[0].split('-')[0].to_i
    end

end

