class Team < ActiveRecord::Base
  attr_accessible :teamname, :abbreviation

  def display_name
    teamname
  end
end
