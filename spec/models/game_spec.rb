require 'spec_helper'

describe Game do
  before(:each) do
    @away = Factory(:team, :teamname => "Dallas Cowboys" ) 
    @home = Factory(:team, :teamname => "New York Jets" ) 
    @attr = {:away_team => @away, :home_team => @home,
             :line => -1, :type => 'Nflgame' }
  end

  it "displays the home favorite team name" do
    game = Game.new(@attr)
    game.favorite_display_name.should == 'at New York Jets'
  end

  it "displays the away underdog team name" do
    game = Game.new(@attr)
    game.underdog_display_name.should == 'Dallas Cowboys'
    
  end

  it "requires a line" do
    no_line = Game.new(@attr.merge(:line => nil))
    no_line.should_not be_valid
  end

  it "displays the away favorite team name" do
    game = Game.new(@attr.merge(:line => 1))
    game.favorite_display_name.should == "Dallas Cowboys"
  end

  it "displays the home underdog" do
    game = Game.new(@attr.merge(:line => 1))
    game.underdog_display_name.should == "at New York Jets"
  end

  it "returns to favorite" do
    game = Game.new(@attr)
    game.favorite.should == @home
  end

  it "returns to underdog" do
    game = Game.new(@attr)
    game.underdog.should == @away
    
  end

  describe "get games to administer" do
    before(:each) do
      away = Factory(:team, :teamname => "Dallas Cowboys" ) 
      home = Factory(:team, :teamname => "New York Jets" ) 

      @progame = Factory(:nflgame, :week => 2, :season => '2011-2012',
                    :away_team => away, :home_team => home)
      @collegegame = Factory(:ncaagame, :week => 3, :season => '2011-2012',
                    :away_team => away, :home_team => home)

    end
    
    it "gets pro games for the given week and season" do
      games = Game.find_by_season_week("2011-2012", 2, "1", "0")
      games[0].should == @progame 
    end

    it "gets college games for the given week and season" do
      games = Game.find_by_season_week("2011-2012", 2, "0", "1")
      games[0].should == @collegegame

    end
  end
end
