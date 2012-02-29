module TeamStatistics
  def PPG(games, team)
    scored_games = 0.0
    points = 0

    games.each do |g|
      # puts "Away: #{g.away_team.display_name}\tHome: #{g.home_team.display_name}"
      points += g.team_score(team)
      scored_games += 1
    end

    if(scored_games == 0.0)
      return 0
    else
      points / scored_games
    end
  end

  def tm_pace(team_id, season=nil, gamedate=nil)
    query = build_team_query(team_id, season, gamedate) 
    season = season_default(season)
    gamedate = gamedate_default(gamedate)
    fga = query.sum('FGA')
    threepa = query.sum("threePA")
    to = query.sum('turnovers')
    orebs = query.sum('ORB')
    fta = query.sum('FTA') 
    puts "team: #{team_id}"
    games = NbaGame.where('season = ? AND gamedate < ? and (away_team_id = ? or home_team_id = ?)', season, gamedate, team_id, team_id).count 
    puts "games: #{games}"

    possessions = fga + threepa + to - orebs + (fta * 0.44)

    puts "possessions: #{possessions}"
    puts "turnovers: #{to}"
    puts "ORB: #{orebs}"
    puts "FGA: #{fga}"
    puts "TPA: #{threepa}"
    possessions / games 
  end

  def team_assists(team_id, season=nil, gamedate=nil)
    query = build_team_query(team_id, season, gamedate)
    
    query.sum("assists")
  end
  
  def team_field_goals(team_id, season=nil, gamedate=nil)
    query = build_team_query(team_id, season, gamedate)
    
    query.sum("FGM") + query.sum("threePM")
  end

  private 
    def build_team_query(team_id, season, gamedate)
      season = season_default(season)
      gamedate = gamedate_default(gamedate)

      NbaGameTeamStat.joins(:nba_game, :nba_team).where("nba_games.season = ? AND nba_games.gamedate < ? AND nba_teams.id = ?", season, gamedate, team_id)
      
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
