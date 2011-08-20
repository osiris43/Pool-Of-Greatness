class Game < ActiveRecord::Base
  attr_accessible :away_team, :home_team, :line, :overunder, :type

  belongs_to :away_team, :foreign_key => 'away_team_id', :class_name => 'Team'
  belongs_to :home_team, :foreign_key => 'home_team_id', :class_name => 'Team'

  #validations
  #
  validates_presence_of :line

  # END validations

  default_scope :order => 'games.gamedate' 

  def favorite_display_name
    if line <= 0
      "at #{home_team.display_name}"
    else
      away_team.display_name
    end
  end

  def underdog_display_name
    if line > 0
      "at #{home_team.display_name}"
    else
      away_team.display_name
    end
  end

  def favorite
    if line <= 0
      home_team
    else
      away_team
    end
  end

  def underdog 
    if line <= 0
      away_team
    else
      home_team
    end
  end
  def self.find_by_season_week(season, week, includePro, includeCollege)
    @games = []
    if includePro == "1"
      @games = Game.where("season = ? AND week = ? AND type = ?",
                         season, week, 'Nflgame') 
    end

    if includeCollege == "1"
      @games.concat(Game.where("season = ? AND week = ? and type = ?",
                               season, week, 'Ncaagame'))
    end
     

    @games
  end

end
