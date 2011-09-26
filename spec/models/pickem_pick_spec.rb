require 'spec_helper'

describe PickemPick do
  before(:each) do
    @pick = Factory(:pickem_pick_with_favorite)
  end

  it "responds to picked_favorite" do
    @pick.picked_favorite?.should be_true
  end

  it "responds to team_id" do
    @pick.should respond_to(:team_id)
  end 


end
