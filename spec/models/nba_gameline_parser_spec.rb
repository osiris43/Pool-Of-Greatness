require 'spec_helper'

describe NbaGamelineParser do
  before(:each) do
    @location = 'spec/models/gameline.html'
  end

  it "is created" do
    NbaGamelineParser.new.should_not be_nil
  end

  it "responds to gameline_doc" do
    gameline = NbaGamelineParser.new
    gameline.should respond_to(:gameline_doc)
  end

  it "creates a gameline doc if nil" do
    gameline = NbaGamelineParser.new
    gameline.gameline_doc.should_not be_nil
  end

  it "responds to games" do
    gameline = NbaGamelineParser.new(@location)
    gameline.should respond_to(:games)
  end

  it "finds all games" do
    gameline = NbaGamelineParser.new(@location)
    gameline.games.length.should == 5
  end

  it "finds away abbreviation" do
    parser = NbaGamelineParser.new(@location)
    away = parser.get_abbreviation(parser.games[0], 'away')
    away.should == 'BOS'
  end

  it "finds home abbreviation" do
    parser = NbaGamelineParser.new(@location)
    away = parser.get_abbreviation(parser.games[0], 'home')
    away.should == 'NYK'
  end

  it "finds game date" do
    parser = NbaGamelineParser.new(@location)
    d = parser.get_gamedate(parser.games[0])
    expected = Date.parse('20111225')
    d.should == expected 
  end

end
