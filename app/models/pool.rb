class Pool < ActiveRecord::Base
  attr_accessible :admin_id, :type, :name, :active
  
  has_one :jackpot
  has_many :transactions
  belongs_to :site
  belongs_to :user, :foreign_key => "admin_id"

  def status
    active ? "Active" : "Inactive"
  end
end
