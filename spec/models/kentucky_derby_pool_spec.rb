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


  it "returns a current window" do
    window = @pool.current_window
    window.should_not be_nil
    window.should == @pool.betting_windows[0]
  end

  it "responds to kentucky_derbies" do
    @pool = KentuckyDerbyPool.new
    @pool.should respond_to(:kentucky_derbies)
  end

  describe "betting windows" do
    it "responds to betting_windows" do
      @pool.should respond_to(:betting_windows)
    end

    it "responds to current_window" do
      @pool = KentuckyDerbyPool.new
      @pool.should respond_to(:current_window)
    end

    it "responds to window_is_open?" do
      @pool = KentuckyDerbyPool.new
      @pool.should respond_to(:window_is_open?)
    end
    
    describe "closed window" do
      before(:each) do
        @pool.betting_windows.create(:open => DateTime.now + 1, :close => DateTime.now + 2)
      end

      it "isn't open" do
        @pool.window_is_open?.should_not be_true
      end
    end
    
    describe "open window" do
      before(:each) do
        @pool.betting_windows.create(:open => DateTime.now - 1, :close => DateTime.now + 2)
      end

      it "is open" do
        @pool.window_is_open?.should be_true
      end
    end

  end
end

