class Jackpot < ActiveRecord::Base
  attr_accessible :weeklyjackpot, :seasonjackpot, :weeklyamount, :seasonamount

  belongs_to :pool
  
end
