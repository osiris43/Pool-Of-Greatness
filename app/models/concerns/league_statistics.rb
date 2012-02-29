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

  def factor(season=nil, gamedate=nil)
    query = build_query(season, gamedate) 

    fieldgoals = query.sum("threePM") + query.sum("FGM")
    assists = query.sum("assists")
    freethrows = query.sum("FTM")

    (2.0/3) - ((0.5 * (assists.to_f/fieldgoals)) / (2 * (fieldgoals.to_f/freethrows)))
  end

  def vop(season=nil, gamedate=nil)
    query = build_query(season, gamedate) 

    points = (query.sum("FGM") * 2) + (query.sum("threePM") * 3) + query.sum("FTM")
    attempted = query.sum("FGA") + query.sum("threePA")
    orb = query.sum("ORB")
    turnovers = query.sum("turnovers")
    fta = query.sum("FTA")

    (points/(attempted - orb + turnovers + 0.44 * fta))
  end

  def drbp(season=nil, gamedate=nil)
    query = build_query(season, gamedate) 

    offensive = query.sum("ORB")
    total = query.sum("TRB")

    ((total.to_f - offensive)/total)
  end

  def lg_pace(season=nil, gamedate=nil)
    query = build_query(season, gamedate) 

    fga = query.sum('FGA') + query.sum("threePA")
    to = query.sum('turnovers')
    orebs = query.sum('ORB')
    fta = query.sum('FTA') 

    games = NbaGame.where('gamedate < ? AND season = ?', gamedate_default(gamedate), season_default(season)).count 
    puts "games: #{games}"

    possessions = fga + to - orebs + (fta * 0.44)

    possessions / games 

  end

  def lg_efficiency(season=nil, gamedate=nil)
    query = build_query(season, gamedate) 
    minutes = query.sum("minutes") / 2
    threePM = query.sum("threePM")
    assists = query.sum("assists")
    fgm = query.sum("FGM") + threePM
    ftm = query.sum("FTM")
    value = vop(season, gamedate)
    fact = factor(season, gamedate)
    def_rebound = drbp(season, gamedate)
    turnovers = query.sum("turnovers")
    fga = query.sum("FGA") + query.sum("threePA")
    fta = query.sum("FTA")
    trb = query.sum("TRB")
    orb = query.sum("ORB")
    steals = query.sum("steals")
    blocks = query.sum("blocks")
    fouls = query.sum("fouls")

    (1/(minutes).to_f) * (threePM + ((2/3) * assists) +
      ((2 - fact * (assists/fgm)) * fgm) +
      (ftm * 0.5 * (1 + (1 - (assists/fgm)) + (2/3) * (assists/fgm))) -
      (value * turnovers) -
      (value * def_rebound * (fga - fgm)) -
      (value * 0.44 * (0.44 + (0.56 * def_rebound)) * (fta - ftm)) +
      (value * (1 - def_rebound) * (trb - orb)) +
      (value * def_rebound * orb) +
      (value * steals) +
      (value * def_rebound * blocks) -
      (fouls * ((ftm/fouls) - 0.44 * (fta/fouls) * value)))
    
  end

  private
    def build_query(season, gamedate)
      season = season_default(season)
      gamedate = gamedate_default(gamedate)

      NbaGameTeamStat.joins(:nba_game).where("nba_games.season = ? AND nba_games.gamedate < ?", season, gamedate)

    end

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
