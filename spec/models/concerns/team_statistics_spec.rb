require 'spec_helper'

class FakeTeam 
  include TeamStatistics
end

describe TeamStatistics do
  before(:each) do
    @game = Factory(:nba_game, :gametime => Time.current, :gamedate => Date.current - 1, :season => "2011-2012")
    @game.nba_game_team_stats.create(:nba_team => @game.away_team, :FGM => 1, :threePM => 2, :assists => 3, :FTM => 4,
                                    :FGA => 5, :ORB => 6, :turnovers => 7, :FTA => 8, :TRB => 9, :threePA => 10)

    @dummy = FakeTeam.new
    Factory(:configuration, :key => "CurrentNbaSeason", :value => "2011-2012") 
  end

  it 'responds to points per game' do
    @dummy.should respond_to(:PPG)
  end

  it 'calculates points per game' do
    @dummy.PPG([@game], @game.home_team).should == 40.0
  end

  it "responds to team_pace" do
    @dummy.should respond_to(:tm_pace)
  end

  it "calculates team pace" do
    @dummy.tm_pace(@game.away_team.id).should == 19.52
  end
end
