require 'spec_helper'

class FakeLeague 
  include LeagueStatistics
end

describe LeagueStatistics do
  before(:each) do
    @game = Factory(:nba_game, :gametime => Time.current, :gamedate => Date.current - 1)
    @game.nba_game_team_stats.create(:nba_team => @game.away_team, :FGM => 1, :threePM => 2, :assists => 3, :FTM => 4,
                                    :FGA => 5, :ORB => 6, :turnovers => 7, :FTA => 8, :TRB => 9, :threePA => 10,
                                    :blocks => 11, :fouls => 12, :steals => 13, :minutes => 48)
    @dummy = FakeLeague.new
    Factory(:db_config, :key => "CurrentNbaSeason", :value => "2011-2012") 
  end

  it "responds to league factor" do
    @dummy.should respond_to(:factor)
  end

  it "calculates factor" do
    @dummy.factor.should == (1.0/3)
  end

  it "calculates factor for current season" do
    game2 = Factory(:nba_game, :season => "2010-2011")
    # this stat should be ignored because it's in a different season
    game2.nba_game_team_stats.create(:nba_team => @game.away_team, :FGM => 3, :threePM => 2, :assists => 3, :FTM => 4)

    @dummy.factor.should == (1.0/3)
  end

  it "responds to vop" do
    @dummy.should respond_to(:vop)
  end

  it "calculates vop" do
    @dummy.vop.should == 12/19.52
  end

  it "calculates vop for the current season" do
    game2 = Factory(:nba_game, :season => "2010-2011")
    # this stat should be ignored because it's in a different season
    game2.nba_game_team_stats.create(:nba_team => @game.away_team, :FGM => 3, :threePM => 2, :assists => 3, :FTM => 4)
    @dummy.vop.should == 12/19.52
  end

  it "calculates drbp" do
    @dummy.drbp.should == 3.0/9
  end

  it "calculates drbp for the current season" do
    game2 = Factory(:nba_game, :season => "2010-2011")
    # this stat should be ignored because it's in a different season
    game2.nba_game_team_stats.create(:nba_team => @game.away_team, :FGM => 3, :threePM => 2, :assists => 3, :FTM => 4, :ORB => 10)

    @dummy.drbp.should == 3.0/9
  end

  it "responds to pace" do
    @dummy.should respond_to(:lg_pace)
  end

  it "calculates pace" do
    @dummy.lg_pace.should == 19.52
  end

  it "responds to efficiency" do
    @dummy.should respond_to(:lg_efficiency)
  end

  it "calculates efficiency" do
    @game.nba_game_team_stats.create(:nba_team => @game.home_team, :FGM => 1, :threePM => 2, :assists => 3, :FTM => 4,
                                    :FGA => 5, :ORB => 6, :turnovers => 7, :FTA => 8, :TRB => 9, :threePA => 10,
                                    :blocks => 11, :fouls => 12, :steals => 13, :minutes => 48)

    @dummy.lg_efficiency.round(4).should == 0.5944
  end
end

