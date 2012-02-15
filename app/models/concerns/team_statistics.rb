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
end
