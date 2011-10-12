class SurvivorSession < ActiveRecord::Base
  attr_accessible :pool, :starting_week, :ending_week, :season, :description

  belongs_to :pool
  has_many :survivor_entries
  has_many :users, :through => :survivor_entries

  def winners(current_week=0)
    current_week = pool.current_week unless current_week != 0

    if current_week < ending_week
      ""
    else
      entries = survivor_entries.where("week = ?", ending_week).find_all{ |entry| entry.result == "Win"}
      names = ""
      entries.each do |entry|
        names += entry.user.name + ',' 
      end

      names[0..-2]
    end
  end
end
