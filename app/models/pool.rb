class Pool < ActiveRecord::Base
  attr_accessible :name, :pool_template_id

  belongs_to :pool_template
  belongs_to :user, :foreign_key => "admin_id"
  has_many :pool_configs
  has_many :poolusers
  has_many :users, :through => :poolusers

  #validations
  validates_uniqueness_of :name

  # END validations
end
