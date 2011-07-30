require 'spec_helper'
require 'date'

describe PickemWeek do
  before(:each) do
    @attr = { :season => "2011-2012", :week => 1, :deadline => DateTime.now }
  end

  it "creates a new week with the correct attributes" do
    PickemWeek.create!(@attr)
  end

  it "requires a season" do
    no_season = PickemWeek.new(@attr.merge(:season => ""))
    no_season.should_not be_valid
  end

  it "requires a week" do
    no_week = PickemWeek.new(@attr.merge(:week => 0))
    no_week.should_not be_valid
  end
end
