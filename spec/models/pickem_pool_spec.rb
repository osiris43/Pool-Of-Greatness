require 'spec_helper'

describe PickemPool do
  before(:each) do
    @attr = { :name => "Pool of Greatness" }
    @pool = PickemPool.create!(@attr)
    @pool.pickem_rules.create!(:config_key => 'current_week', 
                            :config_value => '1')
    @pool.pickem_rules.create!(:config_key => 'current_season', 
                            :config_value => '2011-2012')

  end 

  it "responds to needs_upgrade" do
    @pool.should respond_to(:needs_upgrade?)
  end

  it "needs an upgrade when current_season is last season" do
    @pool.needs_upgrade?.should be_true
  end

  it "responds to update_config" do
    @pool.should respond_to(:update_config)
  end

  describe "config resets" do
    before(:each) do
      @pool.create_jackpot(:weeklyjackpot => 20, :seasonjackpot => 20, :weeklyamount => 1, :seasonamount => 1)
    end

    it "increments the season when config updated" do
      @pool.update_config
      @pool.current_season.should == "2012-2013"
    end
   
    it "resets the current_week to 1" do
      @pool.increment_current_week
      @pool.update_config
      @pool.current_week.should == 1
    end

    it "resets the weekly jackpot" do
      @pool.update_config
      @pool.jackpot.weeklyjackpot.should == 0.0 
    end

    it "resets the season jackpot" do
      @pool.update_config
      @pool.jackpot.seasonjackpot.should == 0.0 
    end

    it "inserts a current pickem week" do
      @pool.update_config
      @pool.current_pickem_week.should_not be_nil
    end
  end

  it "responds to rules" do
    @pool.should respond_to(:pickem_rules) 
  end

  it "must have a unique name" do
    pool = PickemPool.create(@attr)
    pool.should_not be_valid
  end

  it "increments the current_week" do
    @pool.increment_current_week
    @pool.current_week.should == 2 
  end

  it "returns a weekly fee" do
    @pool.create_jackpot(:weeklyjackpot => 0, :seasonjackpot => 0, :weeklyamount => 1, :seasonamount => 1)
    @pool.pickem_rules.create!(:config_key => "weekly_fee", 
                               :config_value => "12")
    @pool.weeklyfee.should == 12.0
  end

  it "returns the base fee for prize amount when there isn't a jackpot" do
    @pool.pickem_rules.create!(:config_key => "weekly_fee", 
                               :config_value => "12")
    @pool.prize_amount_per_person.should == 12.0
  end

  it "returns base fee minus jackpot for prize amount" do
    @pool.create_jackpot(:weeklyjackpot => 0, :seasonjackpot => 0, :weeklyamount => 1, :seasonamount => 1)
    @pool.pickem_rules.create!(:config_key => "weekly_fee", 
                               :config_value => "12")
    @pool.prize_amount_per_person.should == 10.0
  end

  it "returns the current week's deadline" do
    deadline = DateTime.current

    @pool.pickem_weeks.create!(:season => '2011-2012', :week => 1, :deadline => deadline)
    @pool.current_deadline.strftime('%d-%m-%Y').should == deadline.strftime('%d-%m-%Y')
  end

  it "sets the current week's deadline" do
    deadline = DateTime.current + 1
    @pool.pickem_weeks.create!(:season => '2011-2012', :week => 1, :deadline => deadline)

    @pool.current_deadline = deadline
    @pool.current_deadline.strftime('%d-%m-%Y').should == deadline.strftime('%d-%m-%Y')
  end
end
