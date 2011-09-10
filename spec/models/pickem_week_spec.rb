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
      @user.create_account
      @pool.pickem_rules.create(:config_key => "weekly_fee", :config_value => "12")
    end

    it "creates a weekly entry" do
      selectedGames = { "gameid_1" => "23" }
      @pickem_week.save_picks(selectedGames, @user, 43.5)
      @pickem_week.pickem_week_entries.count.should == 1
    end

    it "creates the picks" do
      selectedGames = { "gameid_1" => "23" }
      @pickem_week.save_picks(selectedGames, @user, 43.5)
      @pickem_week = PickemWeek.find(@pickem_week.id)
      @pickem_week.pickem_week_entries[0].pickem_picks.count.should == 1
    end
  end

  describe "scoring week" do
    before(:each) do
      @user = Factory(:user)
      @pool = Factory(:pickem_pool)
      @pickem_week = Factory(:pickem_week, :pickem_pool => @pool)
      @away = Factory(:nflawayteam)
      @home = Factory(:nflhometeam)
      @game = Factory(:nflgame, :away_team => @away, :home_team => @home, :line => -2, :awayscore => 20, :homescore => 23)
    end
   
    it "add a result" do
      @pickem_week.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 45.5)
      @pickem_week.pickem_week_entries[0].pickem_picks.create!( :game => @game, :team => @home)
      @pickem_week.score
      @user.pickem_week_entries[0].pickem_entry_result.should_not be_nil
    end 
  end

  describe "update accounting" do
    before(:each) do
      @user = Factory(:user)
      @pool = Factory(:pickem_pool)
      @pickem_week = Factory(:pickem_week, :pickem_pool => @pool)
      @user.create_account
      @pool.pickem_rules.create(:config_key => "current_week", :config_value => "1") 
      @pool.pickem_rules.create(:config_key => "weekly_fee", :config_value => "10") 
      @pickem_week.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 45.5)
      @away = Factory(:nflawayteam)
      @home = Factory(:nflhometeam)
      @game = Factory(:nflgame, :away_team => @away, :home_team => @home, :line => -2, :awayscore => 20, :homescore => 23)

      @pickem_week.pickem_week_entries[0].pickem_picks.create!( :game => @game, :team => @home)

    end

    it "increments the week when done with accounting" do
      @pickem_week.score
      @pickem_week.update_accounting

      @pool.current_week.should == 2
    end
  end
  
end
