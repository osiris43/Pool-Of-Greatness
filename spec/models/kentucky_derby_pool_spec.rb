require 'spec_helper'

describe KentuckyDerbyPool do
  before(:each) do
    @pool = KentuckyDerbyPool.new(:name => "Darly Downs")
    @pool.save
    @pool.betting_windows.create(:open => DateTime.now.prev_day, :close => DateTime.now.next_day)
  end

  it "is created" do
    KentuckyDerbyPool.new.should be_valid
  end

  it "responds to betting_windows" do
    @pool.should respond_to(:betting_windows)
  end

  it "responds to current_window" do
    @pool = KentuckyDerbyPool.new
    @pool.should respond_to(:current_window)
  end

  it "returns a current window" do
    window = @pool.current_window
    window.should_not be_nil
    window.should == @pool.betting_windows[0]
  end
end

