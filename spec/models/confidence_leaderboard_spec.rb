require 'spec_helper'

describe ConfidenceLeaderboard do
  before(:each) do
    @pool = Factory(:confidence_pool)
    @user1 = Factory(:user)
    @user2 = Factory(:user)
    @bowl = Factory(:bowl, :favorite_score => 0, :underdog_score => 1)
    @user1.confidence_picks.create!(:bowl => @bowl, :team => @bowl.favorite, :rank => 1)
    @user2.confidence_picks.create!(:bowl => @bowl, :team => @bowl.underdog, :rank => 1)
  end

  it "is created" do
    leaderboard = ConfidenceLeaderboard.new(@pool)   
    leaderboard.should_not be_nil
  end

  it "has all entries" do
    leaderboard = ConfidenceLeaderboard.new(@pool)   
    leaderboard.build
    leaderboard.entries.count.should == 2 
  end

end

