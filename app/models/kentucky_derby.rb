class KentuckyDerby < ActiveRecord::Base
  attr_accessible :year

  has_many :horses
  has_and_belongs_to_many :kentucky_derby_pools

  validates :year, :presence => true
end
