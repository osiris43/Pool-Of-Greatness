require 'spec_helper'

describe EspnGameParser do
  before(:each) do
    @location = 'spec/models/espn_boxscore.html'
    @game= EspnGameParser.new(@location)
  end

  it "is created" do
    EspnGameParser.new(@location).should_not be_nil
  end

  it "is not created if no location is provided" do
    lambda { EspnGameParser.new }.should raise_exception
  end

  it "responds to parse" do
    @game.should respond_to(:parse)
  end

  it "parses away_fieldgoals_made" do
    @game.parse
    @game.game_stats["away_fg_made"].should == 39
  end

  it "parses away_fieldgoals_attempted" do
    @game.parse
    @game.game_stats["away_fg_attempted"].should == 90 
  end
  
  it "parses home_fieldgoals_made" do
    @game.parse
    @game.game_stats["home_fg_made"].should == 43 
  end

  it "parses home_fieldgoals_attempted" do
    @game.parse
    @game.game_stats["home_fg_attempted"].should == 98 
  end

  it "parses away_threes_attempted" do
    @game.parse
    @game.game_stats["away_3p_attempted"].should == 29 
  end
  
  it "parses away_threes_made" do
    @game.parse
    @game.game_stats["away_3p_made"].should == 16 
  end
  
  it "parses home_threes_attempted" do
    @game.parse
    @game.game_stats["home_3p_attempted"].should == 22
  end
  
  it "parses home_threes_made" do
    @game.parse
    @game.game_stats["home_3p_made"].should == 10
  end
  
  it "parses away_ft_attempted" do
    @game.parse
    @game.game_stats["away_ft_attempted"].should == 13
  end
  
  it "parses away_ft_made" do
    @game.parse
    @game.game_stats["away_ft_made"].should == 12 
  end
  
  it "parses home_ft_attempted" do
    @game.parse
    @game.game_stats["home_ft_attempted"].should == 21
  end
  
  it "parses home_ft_made" do
    @game.parse
    @game.game_stats["home_ft_made"].should == 18
  end

  it "parses away_orb" do
    @game.parse
    @game.game_stats["away_orb"].should == 10 
  end

  it "parses away_trb" do
    @game.parse
    @game.game_stats["away_trb"].should == 36 
  end

  it "parses home_orb" do
    @game.parse
    @game.game_stats["home_orb"].should == 20
  end

  it "parses home_trb" do
    @game.parse
    @game.game_stats["home_trb"].should == 55
  end

  it "parses away assists" do
    @game.parse
    @game.game_stats["away assists"].should == 25
  end
  
  it "parses home assists" do
    @game.parse
    @game.game_stats["home assists"].should == 21
  end

  it "parses away turnovers" do
    @game.parse
    @game.game_stats["away turnovers"].should == 16
  end
  
  it "parses home turnovers" do
    @game.parse
    @game.game_stats["home turnovers"].should == 18
  end
  
  it "parses away steals" do
    @game.parse
    @game.game_stats["away steals"].should == 10 
  end
  
  it "parses home steals" do
    @game.parse
    @game.game_stats["home steals"].should == 10
  end
  
  it "parses away blocks" do
    @game.parse
    @game.game_stats["away blocks"].should == 9 
  end
  
  it "parses home blocks" do
    @game.parse
    @game.game_stats["home blocks"].should == 4
  end
  
  it "parses away fast break points" do
    @game.parse
    @game.game_stats["away fast break points"].should == 21 
  end
  
  it "parses home fast break points" do
    @game.parse
    @game.game_stats["home fast break points"].should == 20
  end

  it "parses away fouls" do
    @game.parse
    @game.game_stats["away fouls"].should == 21
  end
  
  it "parses home fouls" do
    @game.parse
    @game.game_stats["home fouls"].should == 13 
  end

  it "parses away team" do
    @game.parse
    @game.away_team.should == "Golden State Warriors"
  end

  it "parses home team" do
    @game.parse
    @game.home_team.should == "Sacramento Kings"
  end
  
  it "parses game date" do
    @game.parse
    @game.game_date.strftime('%Y%m%d').should == "20120204"
  end
end

