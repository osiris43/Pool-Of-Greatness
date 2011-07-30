require 'spec_helper'

describe Pool do
  before(:each) do
    @attr = { :name => "Pool of Greatness" }
    @pool = Pool.create(@attr)
  end 

  it "responds to pool configs" do
    @pool.should respond_to(:pool_configs) 
  end

  it "must have a unique name" do
    pool = Pool.create(@attr)
    pool.should_not be_valid
  end
end
