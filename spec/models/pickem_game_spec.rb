require 'spec_helper'

describe PickemGame do
  before(:each) do
    @pool = Factory(:pickem_pool)
    @week = Factory(:pickem_week, :pickem_pool => @pool)
    @team = Factory(:team)
    @team1 = Factory(:team, :teamname => "NY Jets")
    @game = Factory(:nflgame, :home_team => @team, :away_team => @team1)
    
  end
  it "creates an instance with the valid attributes" do
    @week.pickem_games.create!(:game_id => @game.id)

  end

  it "saves it to the database" do
    @week.pickem_games.create!(:game_id => @game.id)
    @poolgame = PickemGame.find_by_id(@week.pickem_games[0].id)
    @poolgame.should be_valid
  end
end
