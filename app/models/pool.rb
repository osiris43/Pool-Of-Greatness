class Pool < ActiveRecord::Base
  attr_accessible :admin_id, :type, :name

  has_one :jackpot
  has_many :transactions
  belongs_to :site
  belongs_to :user, :foreign_key => "admin_id"
end
