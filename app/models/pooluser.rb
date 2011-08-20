class Pooluser < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :pickem_pool, :foreign_key => "pool_id"
  belongs_to :user
end
