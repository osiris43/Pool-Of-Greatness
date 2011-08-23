class PickemWeekEntry < ActiveRecord::Base
  attr_accessible :mondaynighttotal, :user

  belongs_to :user
  belongs_to :pickem_week
  has_many :pickem_picks
  has_one :pickem_entry_result


end
