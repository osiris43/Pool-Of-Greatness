class Pooluser < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :pool
  belongs_to :user
end
