require 'spec_helper'

describe PickemPool do
  before(:each) do
    @attr = { :name => "Pool of Greatness" }
    @pool = PickemPool.create!(@attr)
  end 

  it "responds to rules" do
    @pool.should respond_to(:pickem_rules) 
  end

  it "must have a unique name" do
    pool = PickemPool.create(@attr)
    pool.should_not be_valid
  end

  it "increments the current_week" do
    @pool.pickem_rules.create!(:config_key => 'current_week', 
                            :config_value => '1')
    @pool.increment_current_week
    @pool.pickem_rules[0].config_value.should == "2"
  end

  it "returns a weekly fee minus the jackpot" do
    @pool.create_jackpot(:weeklyjackpot => 0, :seasonjackpot => 0, :weeklyamount => 1, :seasonamount => 1)
    @pool.pickem_rules.create!(:config_key => "weekly_fee", 
                               :config_value => "12")
    @pool.weeklyfee.should == 10.0
  end

  it "returns the base fee when there isn't a jackpot" do
    @pool.pickem_rules.create!(:config_key => "weekly_fee", 
                               :config_value => "12")
    @pool.weeklyfee.should == 12.0
  end
end
