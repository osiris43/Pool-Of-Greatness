require 'spec_helper'

describe EspnScoreboardParser do
  before(:each) do
    @location = 'spec/models/espnscoreboard.html'
  end

  it "is created" do
    EspnScoreboardParser.new.should_not be_nil
  end

  it "responds to games" do
    scoreboard = EspnScoreboardParser.new(@location)
    scoreboard.should respond_to(:games)
  end

  it "finds all games" do 
    scoreboard = EspnScoreboardParser.new(@location)
    games = scoreboard.games
    games.length.should == 3
  end
  
end

