require 'spec_helper'

describe LeaderboardEntry do

  describe "standard information" do
    before(:each) do
      @user = Factory(:user)
      @bowl = Factory(:bowl, :favorite_score => 0, :underdog_score => 1)
    end

    it "is not nil" do
      entry = LeaderboardEntry.new(@user)
      entry.should_not be_nil
    end

    it "has a player's name" do
      entry = LeaderboardEntry.new(@user)
      entry.player.name.should == @user.name
    end

    it "has a won total" do
      # the bowl is scored underdog = 1, favorite = 0
      @user.confidence_picks.create!(:bowl => @bowl, :team => @bowl.underdog, :rank => 1)

      entry = LeaderboardEntry.new(@user)
      entry.score_entry(@bowl.season)
      entry.won.should == 1
    end

    it "has a lost total" do
      # the bowl is scored underdog = 1, favorite = 0
      @user.confidence_picks.create!(:bowl => @bowl, :team => @bowl.favorite, :rank => 1)
     
      entry = LeaderboardEntry.new(@user)
      entry.score_entry(@bowl.season)
      entry.lost.should == 1
    end
   
    it "has a potential score" do
      # the bowl is scored underdog = 1, favorite = 0
      @user.confidence_picks.create!(:bowl => @bowl, :team => @bowl.favorite, :rank => 1)
     
      entry = LeaderboardEntry.new(@user)
      entry.score_entry(@bowl.season)
      entry.potential.should == 0 
    end 

    it "has a percentage right" do
      # the bowl is scored underdog = 1, favorite = 0
      @user.confidence_picks.create!(:bowl => @bowl, :team => @bowl.underdog, :rank => 1)
    
      entry = LeaderboardEntry.new(@user)
      entry.score_entry(@bowl.season)
      entry.percentage.should == 100
    end

    it "has a percentage right with a loss" do
      @bowl2 = Factory(:bowl, :favorite_score => 1, :underdog_score => 0)
      @user.confidence_picks.create!(:bowl => @bowl2, :team => @bowl2.underdog, :rank => 2) 
      # the bowl is scored underdog = 1, favorite = 0
      @user.confidence_picks.create!(:bowl => @bowl, :team => @bowl.underdog, :rank => 1)
      
      entry = LeaderboardEntry.new(@user)
      entry.score_entry(@bowl.season)
      entry.percentage.should == 33.33 

    end

    it "correctly calculates remaining points for multiple bowls" do
      bowl = Factory(:bowl, :favorite_score => 0, :underdog_score => 0)
      bowl2 = Factory(:bowl, :favorite_score => 0, :underdog_score => 0)
      user = Factory(:user)
      user.confidence_picks.create!(:bowl => bowl, :team => bowl.underdog, :rank => 1)
      user.confidence_picks.create!(:bowl => bowl2, :team => bowl2.underdog, :rank => 2)
      entry = LeaderboardEntry.new(user)
      entry.score_entry(@bowl.season)
      entry.left.should == 3
    end

    it "displays the largest remaining pick that hasn't been played" do
      bowl = Factory(:bowl, :favorite_score => 0, :underdog_score => 0)
      bowl2 = Factory(:bowl, :favorite_score => 0, :underdog_score => 0)
      user = Factory(:user)
      user.confidence_picks.create!(:bowl => bowl, :team => bowl.underdog, :rank => 1)
      user.confidence_picks.create!(:bowl => bowl2, :team => bowl2.underdog, :rank => 2)
      entry = LeaderboardEntry.new(user)
      entry.largest_left.should == "Oklahoma Sooners (2)" 
    end

    it "displays the second largest left" do
      bowl = Factory(:bowl, :favorite_score => 0, :underdog_score => 0)
      bowl2 = Factory(:bowl, :favorite_score => 0, :underdog_score => 0)
      user = Factory(:user)
      user.confidence_picks.create!(:bowl => bowl, :team => bowl.underdog, :rank => 1)
      user.confidence_picks.create!(:bowl => bowl2, :team => bowl2.underdog, :rank => 2)
      entry = LeaderboardEntry.new(user)
      entry.second_largest_left.should == "Oklahoma Sooners (1)" 
    end

    it "displays a default message if no picks are left" do
      bowl = Factory(:bowl, :favorite_score => 1, :underdog_score => 0)
      bowl2 = Factory(:bowl, :favorite_score => 0, :underdog_score => 0)
      user = Factory(:user)
      user.confidence_picks.create!(:bowl => bowl, :team => bowl.underdog, :rank => 1)
      user.confidence_picks.create!(:bowl => bowl2, :team => bowl2.underdog, :rank => 2)
      entry = LeaderboardEntry.new(user)
      entry.second_largest_left.should == "None" 

    end
  end

  describe "entries before pool has started" do
    before(:each) do
      @user = Factory(:user)
      @bowl = Factory(:bowl, :underdog_score => 0, :favorite_score => 0)
    end

    it "has points left" do
      # the bowl is scored underdog = 1, favorite = 0
      @user.confidence_picks.create!(:bowl => @bowl, :team => @bowl.favorite, :rank => 1)
      
      entry = LeaderboardEntry.new(@user)
      entry.score_entry(@bowl.season)
      entry.left.should == 1
    end
  end 
end

