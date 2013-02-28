require 'date'

class SurvivorPool < Pool
  attr_accessible :name, :type

  has_many :survivor_sessions, :foreign_key => "pool_id"

  validates_presence_of :admin_id, :site_id

  def get_weekly_games(week=0)
    logger.debug "in weekly games for week #{week}"
    @games = []
    season = getseason
    if week == 0
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

  def current_session
    season = getseason
    nextgame = Nflgame.where("season = ? AND gamedate > ?", season, DateTime.current).order("gamedate").first
    SurvivorSession.where("season = ? AND starting_week <= ? AND ending_week > ?", season, nextgame.week, nextgame.week + 1).first
  end
  private 
    def getseason
      DbConfig.find_by_key("CurrentSeason").value
    end
end
