class Team < ActiveRecord::Base
  attr_accessible :teamname

  def display_name
    teamname
  end
end
