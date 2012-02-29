class EspnGameTeamStats

  def initialize(away, home)
    # away and home are the tbody sections from the espn boxscore
    @away = away
    @home = home
  end

  def parse_stats
    game_stats = {}
    parse_rebounds(game_stats)
    parse_assists(game_stats)
    parse_turnovers(game_stats)
    parse_steals(game_stats)
    parse_blocks(game_stats)
    parse_fastbreakpoints(game_stats)
    parse_fouls(game_stats)
    return game_stats
    
  end

  private 
    def parse_rebounds(stats)
      stats["away_orb"] = @away.search("//td")[4].search("//strong").inner_html.to_i
      stats["away_trb"] = @away.search("//td")[6].search("//strong").inner_html.to_i 
      stats["home_orb"] = @home.search("//td")[4].search("//strong").inner_html.to_i
      stats["home_trb"] = @home.search("//td")[6].search("//strong").inner_html.to_i 

    end

    def parse_assists(stats)
      stats["away assists"] = @away.search("//td")[7].search("//strong").inner_html.to_i 
      stats["home assists"] = @home.search("//td")[7].search("//strong").inner_html.to_i
    end

    def parse_turnovers(stats)
      stats["away turnovers"] = @away.search("//td")[10].search("//strong").inner_html.to_i 
      stats["home turnovers"] = @home.search("//td")[10].search("//strong").inner_html.to_i
    end
    
    def parse_steals(stats)
      stats["away steals"] = @away.search("//td")[8].search("//strong").inner_html.to_i 
      stats["home steals"] = @home.search("//td")[8].search("//strong").inner_html.to_i
    end

    def parse_blocks(stats)
      stats["away blocks"] = @away.search("//td")[9].search("//strong").inner_html.to_i 
      stats["home blocks"] = @home.search("//td")[9].search("//strong").inner_html.to_i
    end

    def parse_fouls(stats)
      stats["away fouls"] = @away.search("//td")[11].search("//strong").inner_html.to_i 
      stats["home fouls"] = @home.search("//td")[11].search("//strong").inner_html.to_i

    end

    def parse_fastbreakpoints(stats)
      awaydata = @away.search("//tr")[2].search("//td")[0].search("//div")[0].inner_text.split(" ")
      stats["away fast break points"] = awaydata[2].match(/\d+/)[0].to_i unless awaydata[2].match(/\d+/).nil?

      homedata = @home.search("//tr")[2].search("//td")[0].search("//div")[0].inner_text.split(" ")
      stats["home fast break points"] = homedata[2].match(/\d+/)[0].to_i unless homedata[2].match(/\d+/).nil?

    end

    def parse_away_stats(stats)
      away_data = @away.search("//tr")[0].search("//td")

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

