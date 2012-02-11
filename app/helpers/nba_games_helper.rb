module NbaGamesHelper
  def page_header
    "#{@game.away_team.display_name} at #{@game.home_team.display_name}"
  end

  def team_score(team, game)
    score = game.team_score(team)
    if(score.nil?)
      "&nbsp;"
    else
      score
    end
  end
end
