class PickemPool < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user, :foreign_key => "admin_id"
  has_many :pickem_rules
  has_many :pickem_weeks
  has_many :poolusers
  has_many :users, :through => :poolusers

  #validations
  validates_uniqueness_of :name

  # END validations
end
