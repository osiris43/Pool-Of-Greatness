class PoolConfig < ActiveRecord::Base
  attr_accessible :pool_id, :config_key, :config_value

  belongs_to :pool

  validates_presence_of :pool_id

end
