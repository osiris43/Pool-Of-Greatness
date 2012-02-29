class EspnGameFreethrows

  def initialize(away, home)
    # away and home are the tbody sections representing the away
    # and home data from the espn boxscore.
    @away = away
    @home = home
  end

  def parse_stats
    game_stats = {}
    parse_home_ft(game_stats)
    parse_away_ft(game_stats)
    return game_stats
    
  end

  private 
    def parse_away_ft(stats)    
      away_data = @away.search("//tr")[0].search("//td")[3].search("//strong")[0].inner_html
      stats["away_ft_attempted"] = away_data.split('-')[1].to_i
      stats["away_ft_made"] = away_data.split('-')[0].to_i
    end
    
    def parse_home_ft(stats)    
      home_data = @home.search("//tr")[0].search("//td")[3].search("//strong")[0].inner_html
      stats["home_ft_attempted"] = home_data.split('-')[1].to_i
      stats["home_ft_made"] = home_data.split('-')[0].to_i
    end

end

