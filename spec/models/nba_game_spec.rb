require 'spec_helper'

describe NbaGame do
  before(:each) do
    @away = Factory(:nbaaway)
    @home = Factory(:nbahome)
    @attr = { :gamedate => '2011-12-25', :gametime => '12:00:00 PM ET', :season => "2011-2012", 
      :away_team => @away, :home_team => @home }
  end

  it "creates an instance with correct attributes" do
    game = NbaGame.new(@attr).should be_valid
  end

  it "responds to away_team" do
    game = NbaGame.new(@attr)
    game.should respond_to(:away_team)
  end

  it "requires a gamedate" do
    NbaGame.new(@attr.merge(:gamedate => "")).should_not be_valid
  end

  it "requires a gametime" do
    NbaGame.new(@attr.merge(:gametime => "")).should_not be_valid
  end

  it "requires a season" do
    NbaGame.new(@attr.merge(:season => "")).should_not be_valid
  end

  it "creates url location" do
    game = NbaGame.new(@attr)
    game.url.should == "http://www.nba.com/games/20111225/DALBOS/gameinfo.html"
  end

  describe "parsing functionality" do
    before(:each) do
      @html = open('spec/models/gameline.html') { |f| Hpricot(f)} 
      @game_html = (@html/'.nbaModOuterBox').first
      @nyk = Factory(:nbaaway, :city => "New York", :mascot => "Knicks", :abbreviation => "NYK")
      @game_date = "2011-12-25"
    end

    it "parses the awayteam" do
      game = NbaGame.parse_from_html(@game_html, @game_date )
      game.away_team.should == @home
    end

    it "parses the home team" do
      game = NbaGame.parse_from_html(@game_html, @game_date)
      game.home_team.should == @nyk
    end

    it "parses the game time" do
      game = NbaGame.parse_from_html(@game_html, @game_date)
      game.gametime.should == Time.parse("12:00:00 PM ET")
    end
  end

  describe "scoring" do
    before(:each) do
      @game = Factory(:nba_game)
    end

    it "responds to away score" do
      @game.should respond_to(:away_score)
    end

    it "has an away score" do
      @game.away_score.should == 15 
    end

    it "responds to home score" do
      @game.should respond_to(:home_score)
    end

    it "has an home score" do
      @game.home_score.should == 40 
    end

  end
end
