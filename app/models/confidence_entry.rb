class ConfidenceEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :confidence_pool, :foreign_key => :pool_id
  has_many :confidence_picks
end
