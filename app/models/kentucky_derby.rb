class KentuckyDerby < ActiveRecord::Base
  attr_accessible :year

  validates :year, :presence => true
end
