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

  it "shows full team name" do
    team = NbaTeam.new(@attr)
    team.display_name.should == "Dallas Mavericks"
  end

  describe "statistics" do
    before(:each) do
      @team = NbaTeam.new(@attr)
      @game = Factory(:nba_game, :gametime => Time.current, :gamedate => Date.current)
    end

    it "has a points per game attribute" do
      @team.should respond_to(:points_per_game)
    end

    it "calculates points per game" do
      @game.home_team.id.should_not == @game.away_team.id
      @game.home_team.points_per_game(@game.gamedate + 1).should == 40.0 
    end

    it "calculates current defensive points modifier" do
      @game1 = Factory(:nba_game, :gamedate => Date.current - 2, :gametime => Time.current, 
                                        :season => '2011-2012', :away_team => @game.away_team,
                                        :home_team => @game.home_team)
      @game2 = Factory(:nba_game, :gamedate => Date.current - 1, :gametime => Time.current, 
                                        :season => '2011-2012', :away_team => @game.away_team,
                                        :home_team => @game.home_team)
      @game1.score.create!(:away_first_q => 10, :home_first_q => 20) 
      @game2.score.create!(:away_first_q => 20, :home_first_q => 20) 

      @game.home_team.defensive_points_mod.should == 1.5
    end

    describe "possessions" do
      before(:each) do
        @game1 = Factory(:nba_game, :gamedate => DateTime.current - 1)
        @game1.nba_game_team_stats.create(:nba_team => @game1.away_team, :FGM => 1, :threePM => 2, :assists => 3, :FTM => 4,
                                        :FGA => 5, :ORB => 6, :turnovers => 7, :FTA => 8, :TRB => 9, :threePA => 10)
        @game1.nba_game_team_stats.create(:nba_team => @game1.home_team, :FGM => 1, :threePM => 2, :assists => 3, :FTM => 4,
                                        :FGA => 5, :ORB => 6, :turnovers => 7, :FTA => 8, :TRB => 9, :threePA => 10)
        Factory(:configuration, :key => "CurrentNbaSeason", :value => "2011-2012") 

      end

      it "responds to possessions" do
        @team.should respond_to(:possessions)
      end

      it "calculates possessions" do
        @game1.away_team.possessions.should == 5
      end
    end
  end
end
