class PoolTemplate < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :pools
end
