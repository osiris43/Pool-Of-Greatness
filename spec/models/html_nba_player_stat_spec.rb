require 'spec_helper'
require 'hpricot'

describe HtmlNbaPlayerStat do
  before(:each) do
    @doc = open('spec/models/single_game.html') { |f| Hpricot(f) }
    @paul_pierce = (@doc/'#nbaGITeamStats').search("//tr")[3]
  end

  it "is created" do
    HtmlNbaPlayerStat.new(@paul_pierce).should_not be_nil
  end

  it "responds to player_name" do
    HtmlNbaPlayerStat.new(@paul_pierce).should respond_to(:player_name)
  end

  it "returns player name" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.player_name.should == "P. Pierce"
  end

  it "responds to minutes" do
    HtmlNbaPlayerStat.new(@paul_pierce).should respond_to(:minutes)
  end

  it "returns player minutes" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.minutes.should == 36
  end

  it "returns player seconds" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.seconds.should == 4 
  end

  it "returns FGM" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.FGM.should == 10 
  end

  it "returns FGA" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.FGA.should == 15 
  end

  it "returns threeGM" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.threeGM.should == 2 
  end

  it "returns threeGA" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.threeGA.should == 5 
  end

  it "returns FTM" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.FTM.should == 12 
  end

  it "returns FTA" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.FTA.should == 15 
  end

  it "returns ORB" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.ORB.should == 1 
  end

  it "returns DRB" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.DRB.should == 7 
  end

  it "returns assists" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.assists.should == 10 
  end

  it "returns fouls" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.fouls.should == 5 
  end

  it "returns steals" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.steals.should == 3 
  end

  it "returns turnovers" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.turnovers.should == 5 
  end

  it "returns blocked_shots" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.blocked_shots.should == 0 
  end

  it "returns had_blocked" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.had_blocked.should == 0 
  end

  it "returns points" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.points.should == 34 
  end

  it "returns player url" do
    stat = HtmlNbaPlayerStat.new(@paul_pierce)
    stat.player_url.should == '/playerfile/paul_pierce/index.html'
  end

  it "responds to position" do

  end
end
