require 'spec_helper'

describe Bowl do
  before(:each) do
    @bowl = Factory(:bowl, :favorite_score => 0, :underdog_score => 1)
  end

  it "has a winning team" do
    @bowl.winning_team.should == @bowl.underdog
  end
end
