require 'spec_helper'
require 'date'

describe SurvivorPool do
  before(:each) do
    @attr = {:name => "Survivor Pool"} 
    @user = Factory(:user)
    @site = @user.sites.create!(:name => "My site", :description => "description")
    @pool = @site.pools.create!(:name => "Survivor Pool", :admin_id => @user.id, :type => "SurvivorPool")
    @pool = SurvivorPool.find(@pool.id)
    @awayteam = Factory(:nflawayteam)
    @hometeam = Factory(:nflhometeam)
    @game = Factory(:nflgame, :away_team => @awayteam, :home_team => @hometeam)
    Factory(:configuration) 
  end

  it "requires an admin_id" do
    SurvivorPool.new(@attr).should_not be_valid
  end

  it "requires a site_id" do
    SurvivorPool.new(@attr.merge(:admin_id => @user.id)).should_not be_valid
  end
 
  it "responds to get_weekly_games" do
    @pool.should respond_to(:get_weekly_games)
  end 

  it "returns weekly games" do
    @games = @pool.get_weekly_games
    @games.count.should == 1
  end

  it "returns weekly games by week" do
    @games = @pool.get_weekly_games(1)
    @games.count.should == 1
  end

  it "returns weekly games after first kickoff" do
    game = Factory(:nflgame, :away_team => @awayteam, :home_team => @hometeam, :gamedate => DateTime.now - 1)
    @games = @pool.get_weekly_games
    @games.count.should == 2
  end

  it "returns currently active session" do
    session = Factory(:survivor_session)
    @pool.current_session.should == session 
  end
end

