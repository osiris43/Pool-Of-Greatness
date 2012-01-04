class Bowl < ActiveRecord::Base
  belongs_to :favorite, :foreign_key => 'favorite_id', :class_name => 'Team'
  belongs_to :underdog, :foreign_key => 'underdog_id', :class_name => 'Team'
  
  default_scope :order => 'bowls.date' 

  def winning_team
    if(favorite_score == underdog_score)
      return nil
    end

    favorite_score > underdog_score ? favorite : underdog
  end

  def self.bowls_left
    count = 0
    @bowls = Bowl.where("season = ?", Configuration.get_value_by_key("CurrentBowlSeason")).all
    
    @bowls.each do |bowl|
      count += 1 unless !bowl.winning_team.nil?
    end 

    count
  end
end
