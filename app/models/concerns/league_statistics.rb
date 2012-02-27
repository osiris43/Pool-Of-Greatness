module LeagueStatistics
  def league_pace(season=nil, gamedate=nil)
    if(season.nil?)
      season = Configuration.find_by_key('CurrentNbaSeason').value
    end

    if(gamedate.nil?)
      gamedate = Date.current
    end

    query = NbaGamePlayerStat.joins(:nba_game).where('nba_games.season = ? AND nba_games.gamedate < ?', season, gamedate )
    fga = query.sum('FGA')
    to = query.sum('turnovers')
    orebs = query.sum('ORB')
    fta = query.sum('FTA') 

    games = NbaGame.where('gamedate < ?', gamedate).count 
    puts "games: #{games}"

    possessions = fga + to - orebs + (fta * 0.44)

    possessions / games
  end

  def league_per(season=nil, gamedate=nil)
    season = season_default(season)
    gamedate = gamedate_default(gamedate)

    query = NbaGamePlayerStat.joins(:nba_game).where('nba_games.season = ? AND nba_games.gamedate < ?', season, gamedate )
    minutes = query.sum('minutes')
    seconds = query.sum('seconds')
    total_time = minutes + (seconds/60)

  end

  def league_def_rebound_ratio(seaason=nil, gamedate=nil)
    season = season_default(season)
    gamedate = gamedate_default(gamedate)

    query = NbaGamePlayerStat.joins(:nba_game).where('nba_games.season = ? AND nba_games.gamedate < ?', season, gamedate )
  end

  private
    def season_default(season)
      if(season.nil?)
        season = Configuration.find_by_key('CurrentNbaSeason').value
      end

      season
    end

    def gamedate_default(gamedate)
      if(gamedate.nil?)
        gamedate = Date.current
      end

      gamedate
    end
end
