class PickemPool < Pool
  belongs_to :user, :foreign_key => "admin_id"
  has_many :pickem_rules
  has_many :pickem_weeks

  #validations
  validates_uniqueness_of :name

  # END validations
  
  def incrementjackpots 
    if jackpot.nil?
      return
    end

    jackpot.weeklyjackpot += jackpot.weeklyamount
    jackpot.seasonjackpot += jackpot.seasonamount
    jackpot.save
  end

  def weeklyfee
    basefee = pickem_rules.find_by_config_key("weekly_fee").config_value.to_f 
    if jackpot.nil?
      basefee
    else
      basefee - jackpot.weeklyamount - jackpot.seasonamount
    end
  end

  def current_week
    pickem_rules.find_by_config_key("current_week").config_value.to_i
  end

  def current_season
    pickem_rules.find_by_config_key("current_season").config_value
  end

  def increment_current_week
    week = pickem_rules.find_by_config_key("current_week")
    week.config_value = week.config_value.to_i + 1
    week.save
  end

  def award_jackpot?(wins) 
    if jackpot.nil?
      false
    else 
      pickem_rules.find_by_config_key("no_of_jackpot_wins").config_value.to_i <= wins
    end 
  end
end
