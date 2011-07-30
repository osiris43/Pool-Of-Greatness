class Team < ActiveRecord::Base
  attr_accessible :city, :mascot

  def display_name
    "#{city} #{mascot}"
  end
end
