module NbaGamesHelper
  def page_header
    "#{@game.away_team.display_name} at #{@game.home_team.display_name}"
  end

end
