class Transaction < ActiveRecord::Base
  attr_accessible :pool_id, :amount, :description, :pooltype, :poolname

  belongs_to :account
  belongs_to :pool
  
  validates_presence_of :amount

end
