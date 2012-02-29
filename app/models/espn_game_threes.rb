class EspnGameThrees

  def initialize(away, home)
    # away and home are the tbody sections from the espn boxscore
    # that contain the data for teams respectively.
    @away = away
    @home = home
  end

  def parse_stats
    game_stats = {}
    parse_home_3p(game_stats)
    parse_away_3p(game_stats)
    return game_stats
    
  end

  private 
    def parse_away_3p(stats)    
      away_data = @away.search("//tr")[0].search("//td")[2].search("//strong")[0].inner_html
      stats["away_3p_attempted"] = away_data.split('-')[1].to_i
      stats["away_3p_made"] = away_data.split('-')[0].to_i
    end
    
    def parse_home_3p(stats)    
      home_data = @home.search("//tr")[0].search("//td")[2].search("//strong")[0].inner_html
      stats["home_3p_attempted"] = home_data.split('-')[1].to_i
      stats["home_3p_made"] = home_data.split('-')[0].to_i
    end

end

