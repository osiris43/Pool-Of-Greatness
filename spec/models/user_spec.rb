require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  def new_user(attributes = {})
    attributes[:username] ||= 'foo'
    attributes[:name] ||= 'Brett Bim'
    attributes[:email] ||= 'foo@example.com'
    attributes[:password] ||= 'abc123'
    attributes[:password_confirmation] ||= attributes[:password]
    User.new(attributes)
  end

  before(:each) do
    User.delete_all
  end

  it "should be valid" do
    new_user.should be_valid
  end

  it "should require username" do
    new_user(:username => '').should have(1).error_on(:username)
  end

  it "requires a name" do
    new_user(:name => '').should have(1).error_on(:name)
  end

  it "should require password" do
    new_user(:password => '').should have(1).error_on(:password)
  end

  it "should require well formed email" do
    new_user(:email => 'foo@bar@example.com').should have(1).error_on(:email)
  end

  it "should validate uniqueness of email" do
    new_user(:email => 'bar@example.com').save!
    new_user(:email => 'bar@example.com').should have(1).error_on(:email)
  end

  it "should validate uniqueness of username" do
    new_user(:username => 'uniquename').save!
    new_user(:username => 'uniquename').should have(1).error_on(:username)
  end

  it "should not allow odd characters in username" do
    new_user(:username => 'odd ^&(@)').should have(1).error_on(:username)
  end

  it "should validate password is longer than 3 characters" do
    new_user(:password => 'bad').should have(1).error_on(:password)
  end

  it "should require matching password confirmation" do
    new_user(:password_confirmation => 'nonmatching').should have(1).error_on(:password)
  end

  it "should generate password hash and salt on create" do
    user = new_user
    user.save!
    user.password_hash.should_not be_nil
    user.password_salt.should_not be_nil
  end

  it "should authenticate by username" do
    user = new_user(:username => 'foobar', :password => 'secret')
    user.save!
    User.authenticate('foobar', 'secret').should == user
  end

  it "should authenticate by email" do
    user = new_user(:email => 'foo@bar.com', :password => 'secret')
    user.save!
    User.authenticate('foo@bar.com', 'secret').should == user
  end

  it "should not authenticate bad username" do
    User.authenticate('nonexisting', 'secret').should be_nil
  end

  it "should not authenticate bad password" do
    new_user(:username => 'foobar', :password => 'secret').save!
    User.authenticate('foobar', 'badpassword').should be_nil
  end

  describe "admin methods" do
    it "responds to admin attribute" do
      new_user().should respond_to(:admin)
    end

    it "is not an admin by default" do
      new_user().should_not be_admin
    end

  end

  describe "weekly entries" do
    it "responds to weekly entries" do
      new_user().should respond_to(:pickem_week_entries)
    end
  end

  it "responds to balance" do
    new_user().should respond_to(:balance)
  end

  it "has the correct balance" do
    user = new_user()
    user.create_account
    user.account.transactions.create!(:pooltype => "Pickem",
                                      :poolname => "Pool",
                                      :amount => -12,
                                      :description => "dis")

    user.balance.should == -12

  end

  describe "survivor accounting" do
    before(:each) do
      @user = new_user()
      @user.create_account
      @user.account.transactions.create(:pooltype => "SurvivorPool",
                                        :poolname => "Pool",
                                        :amount => -50,
                                        :description => "Survivor Pool mid-season 2011-2012 fee")
    end

    it "is debited for the survivor pool" do
      @user.debit_for_survivor?("Survivor Pool mid-season").should == false
    end

    it "is not debited for different survivor pool" do
      @user.debit_for_survivor?("Survivor Pool 2011-2012").should be_true
    end
  end

  describe "pool associations" do
    before(:each) do
      @user = Factory(:user)
      @tourney = Factory(:masters_tournament)
      @pool = Factory(:masters_pool, :masters_tournament => @tourney) 
      @user.masters_pool_entries << MastersPoolEntry.new(:masters_pool => @pool)
    end

    it "responds to golf_wager_pools" do
      @user.should respond_to(:masters_pool_entries)
    end

    it "responds to find_master_pool_entry_by_year" do
      @user.should respond_to(:find_masters_pool_entry_by_year)
    end

    #it "returns the current masters pool" do
    #  year = DateTime.current.year.to_s
    #  MastersTournament.expects(:find_by_year).with(year).returns(@tourney)
    #  MastersPool.expects(:find_by_masters_tournament_id).returns(@pool)
    #  @user.find_masters_pool_entry_by_year.should == @user.masters_pool_entries[0]
    #end
  end
end
