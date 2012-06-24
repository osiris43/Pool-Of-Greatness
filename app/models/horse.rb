class Horse < ActiveRecord::Base
  attr_accessible :name, :opening_odds

  belongs_to :kentucky_derby

  validates :name, :presence => true
end
