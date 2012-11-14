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
      Factory(:nba_season)
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

    it "responds to overtime attribute" do
      @game.should respond_to(:overtime?)
    end

    it "returns true for an overtime game" do
      @game.overtime?.should be_true
    end

    it "responds to played attribute" do
      @game.should respond_to(:played?)
    end

    it "returns true for a played game" do
      @game.played?.should be_true
    end
  end

  describe "games statistics" do
    before(:each) do 
      @game = Factory(:nba_game)
      @game.nba_game_team_stats.create(:nba_team => @game.away_team, :FGM => 1, :threePM => 2, :assists => 3, :FTM => 4,
                                      :FGA => 5, :ORB => 6, :turnovers => 7, :FTA => 8, :TRB => 9, :threePA => 10)
      @game.nba_game_team_stats.create(:nba_team => @game.home_team, :FGM => 1, :threePM => 2, :assists => 3, :FTM => 4,
                                      :FGA => 5, :ORB => 6, :turnovers => 7, :FTA => 8, :TRB => 9, :threePA => 10)

    end

    it "responds to possessions" do
      @game.should respond_to(:possessions)
    end

    it "calculates possessions" do
      @game.possessions(@game.away_team).round(2).should == 15.2 
    end

    it "responds to stat_by_team_and_stattype" do
      @game.should respond_to(:stat_by_team_and_stattype)
    end

    it "returns FGA" do
      @game.stat_by_team_and_stattype(@game.away_team, 'FGA').should == 5
    end
  end
end
