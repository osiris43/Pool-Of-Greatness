class NbaGameScore < ActiveRecord::Base
  belongs_to :nba_game

  before_create :default_values

  def away_total
    away_first_q + away_second_q + away_third_q + away_fourth_q + away_overtime
  end
  
  def home_total
    home_first_q + home_second_q + home_third_q + home_fourth_q + home_overtime
  end

  private
    def default_values
      self.away_first_q ||= 0
      self.away_second_q ||= 0
      self.away_third_q ||= 0
      self.away_fourth_q ||= 0
      self.away_overtime ||= 0
      self.home_first_q ||= 0
      self.home_second_q ||= 0
      self.home_third_q ||= 0
      self.home_fourth_q ||= 0
      self.home_overtime ||= 0

    end
end
