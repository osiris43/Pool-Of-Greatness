require 'spec_helper'
require 'hpricot'

describe HtmlNbaPlayerStat do
  before(:each) do
    @doc = open('spec/models/single_game.html') { |f| Hpricot(f) }
  end 

  it "is created" do
    NbaHtmlBoxscore.new(@doc).should_not be_nil
  end

  it "responds to away stats" do
    box = NbaHtmlBoxscore.new(@doc)
    box.should respond_to(:away_stats)
  end

  it "responds to home stats" do
    box = NbaHtmlBoxscore.new(@doc)
    box.should respond_to(:home_stats)
  end

  it "returns first stat for home team" do
    box = NbaHtmlBoxscore.new(@doc)
    box.home_stats.first.player_name.should == 'C. Singleton'
  end

  it "returns first stat for away team" do
    box = NbaHtmlBoxscore.new(@doc)
    box.away_stats.first.player_name.should == 'P. Pierce'
  end

end

