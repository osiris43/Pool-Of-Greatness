require 'spec_helper'

describe SurvivorEntry do
  before(:each) do
    @away = Factory(:nflawayteam)
    @home = Factory(:nflhometeam)
    @game = Factory(:nflgame, :away_team => @away, :home_team => @home, :awayscore => 1)
    @attr = {:team => @away, :game => @game, :week => @game.week, :season => @game.season}
    @user = Factory(:user)

  end

  it "responds to result" do
    @entry = @user.survivor_entries.create!(@attr)
    @entry.should respond_to(:result)
  end

  it "results in a loss" do
    @game.stubs(:winning_team).returns(@home)
    @entry = @user.survivor_entries.create!(@attr)
    @entry.result.should == "Loss"
  end

  it "results in a win" do
    @game.stubs(:winning_team).returns(@away)
    @entry = @user.survivor_entries.create!(@attr)
    @entry.result.should == "Win"
  end

end
