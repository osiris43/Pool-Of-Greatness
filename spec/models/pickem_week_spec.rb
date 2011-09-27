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
      @game = Factory(:nflgame)
      @user.create_account
      @pool.pickem_rules.create(:config_key => "weekly_fee", :config_value => "12")
    end

    it "creates a weekly entry" do
      selectedGames = { "gameid_#{@game.id}" => @game.away_team.id.to_s }
      @pickem_week.save_picks(selectedGames, @user, 43.5)
      @pickem_week.pickem_week_entries.count.should == 1
    end

    it "creates a pickem_pick" do
      lambda do
        selectedGames = { "gameid_#{@game.id}" => @game.away_team.id.to_s }
        @pickem_week.save_picks(selectedGames, @user, 43.5)
      end.should change(PickemPick, :count).by(1)
    end

    it "updates the team_id" do
      selectedGames = { "gameid_#{@game.id}" => @game.away_team.id.to_s }
      @pickem_week.save_picks(selectedGames, @user, 43.5)
      @pickem_week = PickemWeek.first
      @pickem_week.pickem_week_entries[0].pickem_picks[0].team_id.should == @game.away_team.id
    end
    
    it "updates the game_id" do
      selectedGames = { "gameid_#{@game.id}" => @game.away_team.id.to_s }
      @pickem_week.save_picks(selectedGames, @user, 43.5)
      @pickem_week = PickemWeek.first
      @pickem_week.pickem_week_entries[0].pickem_picks[0].game_id.should == @game.id
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
      @user.create_account
      @pickem_week = Factory(:pickem_week)
      @pickem_week.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 45.5)
      @game = Factory(:nflgame)
      @pickem_week.pickem_week_entries[0].pickem_picks.create!( :game => @game, :team => @game.home_team)

    end

    it "increments the week when done with accounting" do
      @pickem_week.score
      @pickem_week.update_accounting
      @pickem_week.pickem_pool.current_week.should == 2
    end

    it "splits the pot for a tie" do
      @user2 = Factory(:user, :username => "test2", :email => "test1@test.com")
      @user2.create_account
      @pickem_week.pickem_week_entries.create!(:user => @user2, :mondaynighttotal => 45.5)
      @pickem_week.pickem_week_entries[1].pickem_picks.create!(:game => @game, :team => @game.home_team)
      @pickem_week.score
      @pickem_week.update_accounting
      @user2 = User.find(@user2.id)
      @user2.account.transactions[0].should_not be_nil
      @user2.account.transactions[0].amount.should == 10
    end
  end
  
end
