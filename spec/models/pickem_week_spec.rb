require 'spec_helper'
require 'date'

describe PickemWeek do
  before(:each) do
    @attr = { :season => "2011-2012", :week => 1, :deadline => DateTime.now }
  end

  it "creates a new week with the correct attributes" do
    PickemWeek.create!(@attr)
  end

  it "requires a season" do
    no_season = PickemWeek.new(@attr.merge(:season => ""))
    no_season.should_not be_valid
  end

  it "requires a week" do
    no_week = PickemWeek.new(@attr.merge(:week => 0))
    no_week.should_not be_valid
  end

  describe "saving weekly picks" do
    before(:each) do
      @user = Factory(:user)
      @pool = Factory(:pickem_pool)
      @pickem_week = Factory(:pickem_week, :pickem_pool => @pool)
    end

    it "creates a weekly entry" do
      selectedGames = { "gameid_1" => "23" }
      @pickem_week.save_picks(selectedGames, @user, 43.5)
      @pickem_week.pickem_week_entries.count.should == 1
    end

    it "creates the picks" do
      selectedGames = { "gameid_1" => "23" }
      @pickem_week.save_picks(selectedGames, @user, 43.5)
      @pickem_week.pickem_week_entries[0].pickem_picks.count.should == 1
    end
  end
  
end
