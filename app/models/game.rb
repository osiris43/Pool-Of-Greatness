class Game < ActiveRecord::Base
  attr_accessible :away_team, :home_team, :line, :overunder, :type, 
    :awayscore, :homescore, :away_team_id, :home_team_id, :week, :season, :gamedate
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

    # college starts a week before pro.
    if includeCollege == "1"
      @games = Game.where("season = ? AND week = ? and type = ?",
                               season, week.to_i + 1, 'Ncaagame').order("gamedate ASC")
    end

    if includePro == "1"
      @games.concat(Game.where("season = ? AND week = ? AND type = ?",
                         season, week, 'Nflgame').order("gamedate ASC"))
    end

     

    @games
  end

  def winning_team_ats
    if line + homescore > awayscore
      return home_team
    elsif line + homescore < awayscore 
      return away_team
    else
      return nil 
    end
  end

  def winning_team
    if homescore > awayscore
      return home_team
    else
      return away_team
    end
  end

  def display_line
    if line > 0
      line * -1
    else
      line
    end
  end

  def scored?
    homescore > 0 || awayscore > 0
  end

  def overunder_result
    if awayscore + homescore == overunder
      'PUSH'
    elsif awayscore + homescore < overunder
      'UNDER'
    else
      'OVER'
    end
  end

  def underdog_score
    line < 0 ? awayscore : homescore
  end

  def favorite_score
    line <= 0 ? homescore : awayscore
  end
end
