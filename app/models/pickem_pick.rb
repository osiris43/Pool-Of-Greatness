class PickemPick < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  belongs_to :user
  belongs_to :pickem_week_entry
end
