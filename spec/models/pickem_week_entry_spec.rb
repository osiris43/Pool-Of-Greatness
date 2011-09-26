require 'spec_helper'

describe PickemWeekEntry do
  before(:each) do
    @entry = Factory(:pickem_week_entry)
    @game1 = Factory(:sequence_game)
    @game2 = Factory(:sequence_game)
    @pick2 = @entry.pickem_picks.create!(:team_id => @game2.home_team.id, :game_id => @game2.id)
    @pick1 = @entry.pickem_picks.create!(:team_id => @game1.away_team.id, :game_id => @game1.id)

  end 

  it "should order the games according to date then id" do
    @entry.pickem_picks.should == [@pick1, @pick2]
  end

end

