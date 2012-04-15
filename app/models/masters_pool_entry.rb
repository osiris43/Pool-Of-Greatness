class MastersPoolEntry < ActiveRecord::Base
  belongs_to :masters_pool
  belongs_to :user
end
