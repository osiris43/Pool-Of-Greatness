module NbaHelpers
  def season_default(season)
    if(season.nil?)
      season = DbConfig.find_by_key('CurrentNbaSeason').value
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
