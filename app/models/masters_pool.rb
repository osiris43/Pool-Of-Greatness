class MastersPool < ActiveRecord::Base
  belongs_to :golf_wager_pool
  has_one :masters_tournament
end
