require 'spec_helper'

describe NbaTeam do
  before(:each) do
    @div = Factory(:nba_division)
    @attr = {:city => "Dallas", :mascot => "Mavericks", :abbreviation => "DAL", :nba_division => @div}
  end

  it "is created with correct attributes" do
    team = NbaTeam.new(@attr)
    team.should_not be_nil
  end

  it "responds to city" do
    NbaTeam.new(@attr).should respond_to(:city)
  end

  it "responds to mascot" do
    NbaTeam.new(@attr).should respond_to(:mascot)
  end

  it "responds to abbreviation" do
    NbaTeam.new(@attr).should respond_to(:abbreviation)
  end

end
