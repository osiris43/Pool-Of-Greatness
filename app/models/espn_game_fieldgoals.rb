class EspnGameFieldgoals

  def initialize(away, home)
    # away and home are tbody sections from the ESPN boxscore
    # for the given home game.  They each contain the necessary
    # data for each team
    @away = away
    @home = home  
  end

  def parse_stats 
    game_stats = {}
    parse_home_fg(game_stats)
    parse_away_fg(game_stats)
    return game_stats
  end

  private
    def parse_home_fg(stats)
      home_data = @home.search("//tr")[0].search("//td")[1].search("//strong")[0].inner_html
      stats["home_fg_made"] = home_data.split('-')[0].to_i
      stats["home_fg_attempted"] = home_data.split('-')[1].to_i
    end

    def parse_away_fg(stats)
      away_data = @away.search("//tr")[0].search("//td")[1].search("//strong")[0].inner_html
      stats["away_fg_made"] = away_data.split('-')[0].to_i
      stats["away_fg_attempted"] = away_data.split('-')[1].to_i
    end
end
