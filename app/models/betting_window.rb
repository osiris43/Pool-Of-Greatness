class BettingWindow < ActiveRecord::Base
  attr_accessible :open, :close

  belongs_to :kentucky_derby_pool

  validates :kentucky_derby_pool_id, :presence => true

end
