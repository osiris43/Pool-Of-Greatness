require 'spec_helper'

describe Site do
  def new_site(attributes = {})
    attributes[:name] ||= 'my site name'
    attributes[:description] ||= "my site description"
    attributes[:slug] ||= "mysiteslug"
    Site.new(attributes)
  end

  it "requires a name" do
    new_site({:name => ""}).should_not be_valid
  end

  it "returns users with their totals" do
    pool = Factory(:pickem_pool)
    user = Factory(:user)
    user.create_account
    user.account.transactions.create!(:amount => -12, :pool_id => pool.id)
    site = new_site
    site.stubs(:transactions).returns(user.account.transactions)
    user_transactions = site.transactions_by_user
    user_transactions[user.name].should == -12 
  end
end
