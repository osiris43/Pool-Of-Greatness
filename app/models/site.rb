class Site < ActiveRecord::Base
  belongs_to :user, :foreign_key => "admin_id"
  has_and_belongs_to_many :users
  has_many :pools
  has_many :transactions, :through => :pools

  # Validations
  validates_presence_of :name

  def transactions_by_user
    userdata = {}
    accounts = transactions.group_by(&:account)
    accounts.each do |account, trans|
      amount = trans.inject(0){|acc, t| acc += t.amount}
      userdata[account.user.name] = amount
      
    end

    return userdata
  end
end
