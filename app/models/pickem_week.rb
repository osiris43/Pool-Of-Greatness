class PickemWeek < ActiveRecord::Base
  attr_accessible :season, :week, :deadline

  belongs_to :pool

  validates :season, :presence => true
  validates_numericality_of :week, :greater_than => 0
end
