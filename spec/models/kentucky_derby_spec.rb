require 'spec_helper'

describe KentuckyDerby do
  before(:each) do
    @attr = {:year => "2011"}
  end

  it "is created" do
    KentuckyDerby.new(@attr).should be_valid
  end

  it "requires a year" do
    KentuckyDerby.new(@attr.merge(:year => "")).should_not be_valid
  end

  it "responds to horses" do
    @derby = KentuckyDerby.new(@attr)
    @derby.should respond_to(:horses)
  end

  it "responds to kentucky_derby_pools" do
    @derby = KentuckyDerby.new(@attr)
    @derby.should respond_to(:kentucky_derby_pools)
  end
end
