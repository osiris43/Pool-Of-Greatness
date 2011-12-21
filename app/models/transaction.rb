class Transaction < ActiveRecord::Base
  attr_accessible :pool_id, :amount, :description, :pooltype, :poolname, :account_id

  belongs_to :account
  belongs_to :pool
  
  validates_presence_of :amount
  
  default_scope :order => 'transactions.created_at' 

end
