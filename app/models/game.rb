class Game < ActiveRecord::Base
  attr_accessible :away_team, :home_team, :line, :overunder

  belongs_to :away_team, :foreign_key => 'away_team_id', :class_name => 'Team'
  belongs_to :home_team, :foreign_key => 'home_team_id', :class_name => 'Team'

  #validations
  #
  validates_presence_of :line

  # END validations

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
end
