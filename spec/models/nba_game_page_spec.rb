require 'spec_helper'
require 'Hpricot'

describe NbaGamePage do
  before(:each) do
    @url = 'spec/models/single_game.html'
  end 
  
  it 'is created' do
    NbaGamePage.new(@url).should_not be_nil
  end 

  it 'responds to box score' do
    NbaGamePage.new(@url).should respond_to(:boxscore)
  end
  
  describe "parsing scoring" do
    before(:each) do
      @overtime_gl = 'spec/models/overtime_gameline.html'
    end

    it "parses the away scores" do
      parser = NbaGamePage.new(@url)
      parser.scores_by_team('away').should == [20,29,24,27]
    end
    
    it "parses the home scores" do
      parser = NbaGamePage.new(@url)
      parser.scores_by_team('home').should == [21,19,29,25]
    end

    it "parses away overtime scores" do
      parser = NbaGamePage.new(@overtime_gl)
      parser.scores_by_team('away').should == [25,21,26,26,7,14]
    end

    it "parses home overtime scores" do
      parser = NbaGamePage.new(@overtime_gl)
      parser.scores_by_team('home').should == [24,30,18,26,7,9]
    end
  end
end

