require 'spec_helper'

describe PickemPick do
  before(:each) do
    @away = Factory(:nflawayteam)
    @home = Factory(:nflhometeam)
    @game = Factory(:nflgame, :away_team => @away, :home_team => @home, :gamedate => DateTime.now + 2)
    @game1 = Factory(:nflgame, :away_team => @away, :home_team => @home, :gamedate => DateTime.now + 1)

    @user = Factory(:user)
    @user.pickem_picks.create!(:team => @away, :game => @game)
    @user.pickem_picks.create!(:team => @home, :game => @game1)
  end

end
