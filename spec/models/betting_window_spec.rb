require 'spec_helper'

describe BettingWindow do
  before(:each) do
    @attr = {:open => '2012-05-01 08:00:00', :close => '2012-05-01 20:00:00'}
    @pool = Factory(:kentucky_derby_pool)
  end

  describe 'validations' do
    it "is successfully created" do
      BettingWindow.new(@attr).should_not be_valid
    end

    it "requires a valid open date" do
      BettingWindow.new(@attr.merge(:open => 'a')).should_not be_valid
    end
  end

  describe "pool associations" do
    before(:each) do
      @betting_window = @pool.betting_windows.create(@attr)
    end
   
    it "has a kentucky_derby_pool attribute" do
      @betting_window.should respond_to(:kentucky_derby_pool)
    end 

    it "has the right associated pool" do
      @betting_window.kentucky_derby_pool_id.should == @pool.id
      @betting_window.kentucky_derby_pool.should == @pool
    end

  end

end
