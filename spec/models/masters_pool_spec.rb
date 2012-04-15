require 'spec_helper'

describe MastersPool do
  before(:each) do
    @pool = Factory(:masters_pool)
  end

  it "responds to golf_wager_pool" do
    @pool.should respond_to(:golf_wager_pool)
  end
end
