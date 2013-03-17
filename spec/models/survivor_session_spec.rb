require 'spec_helper'

describe SurvivorSession do
  it "returns the winners" do
    @session = SurvivorSession.create!(:starting_week => 1, :ending_week => 5)
    game = Factory(:nflgame)
    user = Factory(:user)
    user.survivor_entries.create!(:week => 5, :season => "2011-2012", :team => game.home_team, :game => game, :survivor_session => @session)
    
    @session.winners(6).should == user.name
  end
end
