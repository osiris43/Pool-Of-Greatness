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

  def team_pace(team_id, season=nil, gamedate=nil)
    if(season.nil?)
      season = Configuration.find_by_key('CurrentNbaSeason').value
    end

    if(gamedate.nil?)
      gamedate = Date.current
    end
    
    query = NbaGamePlayerStat.joins(:nba_game, :nba_player => :nba_team).where('nba_games.season = ? AND nba_games.gamedate < ? AND nba_teams.id = ?', season, gamedate,team_id )
    fga = query.sum('FGA')
    to = query.sum('turnovers')
    orebs = query.sum('ORB')
    fta = query.sum('FTA') 

    games = NbaGame.where('gamedate < ? and (away_team_id = ? or home_team_id = ?)', gamedate, team_id, team_id).count 
    puts "games: #{games}"

    possessions = fga + to - orebs + (fta * 0.44)

    possessions / games 
  end
end
