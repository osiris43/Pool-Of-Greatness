require 'spec_helper'

describe PickemPool do
  before(:each) do
    @attr = { :name => "Pool of Greatness" }
    @pool = PickemPool.create(@attr)
  end 

  it "responds to rules" do
    @pool.should respond_to(:pickem_rules) 
  end

  it "must have a unique name" do
    pool = PickemPool.create(@attr)
    pool.should_not be_valid
  end
end
