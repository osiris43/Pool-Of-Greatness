require 'spec_helper'

describe NbaGameScore do
  before(:each) do
    @game = Factory(:nba_game)
    @attr = {:nba_game => @game, :away_first_q => 1, :away_second_q => 2, :away_third_q => 3, :away_fourth_q => 4,
      :away_overtime => 5, :home_first_q => 6, :home_second_q => 7, :home_third_q => 8, :home_fourth_q => 9,
      :home_overtime => 10}
  end

  it "is created" do
    NbaGameScore.new(@attr).should_not be_nil
  end

  it "has an away total score" do
    score = NbaGameScore.new(@attr.merge(:away_overtime => 0))
    score.away_total.should == 10
  end

  it "has an home total score" do
    score = NbaGameScore.new(@attr)
    score.home_total.should == 40 
  end

  it "has an away first quarter score" do
    score = NbaGameScore.new(@attr)
    score.away_first_q.should == 1 
  end
end
