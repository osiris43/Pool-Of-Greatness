class Site < ActiveRecord::Base
  belongs_to :user, :foreign_key => "admin_id"
  has_and_belongs_to_many :users
  has_many :pools
  has_many :transactions, :through => :pools

  # Validations
  validates_presence_of :name

end
