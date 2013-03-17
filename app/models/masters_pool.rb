class MastersPool < ActiveRecord::Base
  belongs_to :golf_wager_pool
  belongs_to :masters_tournament
end
