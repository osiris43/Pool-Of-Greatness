require 'spec_helper'

describe Game do
  before(:each) do
    away = Factory(:team, :city => "Dallas", :mascot => "Cowboys" )
    home = Factory(:team, :city => "New York", :mascot => "Jets" )
    @attr = {:away_team => away, :home_team => home,
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
end
