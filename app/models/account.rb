class Account < ActiveRecord::Base
  belongs_to :user
  has_many :transactions

  def last_transactions(n)
    cur_season = DbConfig.get_value_by_key('CurrentSeason')
    transactions.where(:season => cur_season).find(:all, :limit => n, :order => 'created_at DESC')
  end
end
