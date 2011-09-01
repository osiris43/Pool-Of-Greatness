require 'date'

class SurvivorPool < Pool
  attr_accessible :name, :type

  validates_presence_of :admin_id, :site_id

  def get_weekly_games(week=0)
    logger.debug "in weekly games for week #{week}"
    @games = []
    season = getseason
    if week == 0
      # TODO manage seasons
      nextgame = Nflgame.where("season = ? AND gamedate > ?", season, DateTime.now).order("gamedate").first
      
      @games = Nflgame.where("season = ? AND week = ?", season, nextgame.week)
    else
      @games = Nflgame.where("season = ? AND week = ?", season, week)
    end

    @games
  end

  def current_week
    Nflgame.where("season = ? AND gamedate > ?", getseason, DateTime.now).order("gamedate").first.week
  end

  def show_week?
    game = Nflgame.where("season = ? AND gamedate > ?", getseason, DateTime.now).order("gamedate").first

    if DateTime.now < game.gamedate
      false
    else
      true
    end
  end

  def past_deadline
    nextgame = Nflgame.where("season = ? AND gamedate > ?", getseason, DateTime.now).order("gamedate").first
    previousgame = Nflgame.where("season = ? AND gamedate < ?", getseason, DateTime.now).order("gamedate").first

    if previousgame.nil?
      false
    elsif nextgame.week == previousgame.week
      true 
    else
      false
    end
  end

  private 
    def getseason
      "2011-2012"
    end
end
