class PickemPool < Pool
  belongs_to :user, :foreign_key => "admin_id"
  has_many :pickem_rules
  has_many :pickem_weeks

  #validations
  validates_uniqueness_of :name

  # END validations
 
  def needs_upgrade?
    # 1-16-2013 This seems completely arbitrary and will fail whenever this test
    # is run before march 1 of any given year.  Not sure why it's here, commenting
    # out for now.
    #artificialDeadline = Date.new(Date.today.year, 3, 1)
    #if Date.today < artificialDeadline
    #  return false 
    #else
    season = "#{Date.today.year}-#{Date.today.year + 1}"
    needs_upgrade = season == current_season ? false : true 
    #end

    needs_upgrade
  end 
 
  def update_config
    if !needs_upgrade?
      return
    end

    newseason = "#{Date.today.year}-#{Date.today.year + 1}"
    season_rule = pickem_rules.find_by_config_key("current_season")
    season_rule.config_value = newseason
    season_rule.save


    week_rule = pickem_rules.find_by_config_key("current_week")
    week_rule.config_value = "1" 
    week_rule.save

    jackpot.weeklyjackpot = 0
    jackpot.seasonjackpot = 0
    jackpot.save

    if current_pickem_week.nil?
      week = PickemWeek.create!(:pickem_pool_id => id, :season => current_season, 
                     :week => current_week, :deadline => '2012-09-08')
      week.save
    end
  end 

  def incrementjackpots 
    if jackpot.nil?
      return
    end

    jackpot.weeklyjackpot += jackpot.weeklyamount
    jackpot.seasonjackpot += jackpot.seasonamount
    jackpot.save
  end

  def weeklyfee
    pickem_rules.find_by_config_key("weekly_fee").config_value.to_f 
  end

  def prize_amount_per_person
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

  def current_deadline(week=0)
    current_pickem_week.deadline
  end

  def current_deadline=(deadline)
    week = current_pickem_week
    week.deadline = deadline
    week.save
  end

  def current_pickem_week(week=0)
    if week.nil? || week == 0
      week = current_week 
    end
    
    pickem_weeks.where("season = ? AND week = ?", current_season, week).first
  end
  
end
