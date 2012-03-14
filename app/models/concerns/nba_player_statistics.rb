module NbaPlayerStatistics
  include TeamStatistics
  include LeagueStatistics

  def efficiency(player_id, season=nil, gamedate=nil)
    query = build_player_query(player_id, season, gamedate)
    season = season_default(season)
    gamedate = gamedate_default(gamedate)
    player = NbaPlayer.find(player_id)
    team_assists = team_assists(player.nba_team_id, season, gamedate)
    team_fieldgoals = team_field_goals(player.nba_team_id, season, gamedate)

    minutes = query.sum("minutes") + (query.sum("seconds") / 60)
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
    drb = query.sum("DRB")
    orb = query.sum("ORB")
    steals = query.sum("steals")
    blocks = query.sum("blocks")
    fouls = query.sum("fouls")
    if fouls == 0
      fouls = 1
    end

    uPer = (1/minutes.to_f) * 
      (threePM + 
       (2/3) * assists +
       (2 - fact * (team_assists/team_fieldgoals)) * fgm +
       (ftm * 0.5 * (1 + (1 - (team_assists/team_fieldgoals)) + (2/3) * (team_assists/team_fieldgoals))) -
       value * turnovers -
       value * def_rebound * (fga - fgm) -
       value * 0.44 * (0.44 + (0.56 * def_rebound)) * (fta - ftm) +
       value * (1 - def_rebound) * ((drb+orb) - orb) +
       value * def_rebound * orb +
       value * steals +
       value * def_rebound * blocks -
       fouls * ((ftm/fouls) - 0.44 * (fta/fouls) * value))

    (uPer * (lg_pace(season, gamedate) / tm_pace(player.nba_team_id, season, gamedate))) * (15/lg_efficiency(season, gamedate))
    uPer 
  end

  private
    def build_player_query(player_id, season, gamedate)
      season = season_default(season)
      gamedate = gamedate_default(gamedate)

      NbaGamePlayerStat.joins(:nba_game).where("nba_games.season = ? AND nba_games.gamedate < ? AND nba_player_id = ?", season, gamedate, player_id)

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
