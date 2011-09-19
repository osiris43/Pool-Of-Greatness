require 'spec_helper'

describe BodogEvent do
  before(:each) do
    @html = File.read(Rails.root + 'spec/models/bodogevent.txt')
    @event = BodogEvent.new(@html)
  end

  it "creates a new instance" do
    @event.html.should == @html
  end

  it "parses the away team" do
    @event.parse
    @event.away_team.should == "Chicago Bears"
  end

  it "parses the home team" do
    @event.parse
    @event.home_team.should == "New Orleans Saints"
  end

  it "parses the line" do
    @event.parse
    @event.line.should == -7
  end

  it "parses the overunder" do
    @event.parse
    @event.overunder.should == 47.5
  end
end

