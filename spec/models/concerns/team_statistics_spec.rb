require 'spec_helper'

class FakeTeam 
  include TeamStatistics
end

describe TeamStatistics do
  before(:each) do
    @game = Factory(:nba_game, :gametime => Time.current, :gamedate => Date.current)
    @dummy = FakeTeam.new
  end

  it 'responds to points per game' do
    @dummy.should respond_to(:PPG)
  end

  it 'calculates points per game' do
    @dummy.PPG([@game], @game.home_team).should == 40.0
  end
end
