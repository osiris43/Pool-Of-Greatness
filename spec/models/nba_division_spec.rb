require 'spec_helper'

describe NbaDivision do
  before(:each) do
    @conf = Factory(:nba_conference)
    @attr = {:name => "My division", :nba_conference => @conf}
  end

  it "creates a division with correct attributes" do
    division = NbaDivision.new(@attr)
    division.should_not be_nil
  end

  it "responds to name" do
    NbaDivision.new(@attr).should respond_to(:name)
  end

  it "responds to conference" do
    NbaDivision.new(@attr).should respond_to(:nba_conference)
  end
end
