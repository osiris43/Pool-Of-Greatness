require 'spec_helper'

describe PoolConfig do
  it "requires a pool id" do
    config = PoolConfig.new
    config.should_not be_valid
  end
  
end
