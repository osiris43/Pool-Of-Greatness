class PickemRule < ActiveRecord::Base
  attr_accessible :config_key, :config_value

  belongs_to :pickem_pool
  validates_presence_of :pickem_pool_id

end
