class Account < ActiveRecord::Base
  belongs_to :user
  has_many :transactions

  def last_transactions(n)
    transactions.find(:all, :limit => n, :order => 'created_at DESC')
  end
end
