require 'spec_helper'

describe Team do
  before(:each) do
    @attr = {:teamname => "Dallas Cowboys"}
  end
  it "has a display name" do
    team = Team.create(@attr)
    team.display_name == "Dallas Cowboys" 
  end

  describe "games" do
    before(:each) do
      Factory(:configuration)
      @away = Factory(:team, :teamname => "Dallas Cowboys" ) 
      @home = Factory(:team, :teamname => "New York Jets" ) 
      @attr = {:away_team => @away, :home_team => @home,
              :gamedate => DateTime.current, :season => "2011-2012",
              :line => -1, :type => 'Nflgame', :homescore => 4, :awayscore => 0 }
    end

    it "has away games" do
      @game = Game.create!(@attr)
      @away.away_games.count.should == 1 
    end

    it "has home games" do
      @game = Game.create!(@attr)
      @home.home_games.count.should == 1
    end

    it "has games" do
      @game = Game.create!(@attr)
      @away.games[0].id.should == @game.id
    end

    describe "gambling records" do
      it "returns ATS wins" do
        @game = Game.create!(@attr)
        @home.ats_wins.should == 1
      end

      it "returns ATS losses" do
        @game = Game.create!(@attr)
        @away.ats_losses.should == 1
      end

      it "returns ATS pushes" do
        @game = Game.create!(@attr.merge(:homescore => 1))
        @home.ats_pushes.should == 1
      end

      it "shows this week's opponent" do
        @game = Game.create!(@attr.merge(:gamedate => DateTime.current + 1))
        @home.this_weeks_opponent.display_name.should == "Dallas Cowboys" 
      end

      it "shows this week's game" do
        @game = Game.create!(@attr.merge(:gamedate => DateTime.current + 1))
        @home.this_weeks_game.id.should == @game.id
      end

      it "returns underdog losses" do
        @game = Game.create!(@attr.merge(:homescore => 4))
        @away.underdog_losses.should == 1
      end

      it "returns underdog wins" do
        @game = Game.create!(@attr.merge(:awayscore => 10))
        @away.underdog_wins.should == 1
      end

      it "returns favorite losses" do
        @game = Game.create!(@attr.merge(:awayscore => 4))
        @home.favorite_losses.should == 1
      end

      it "returns favorite wins" do
        @game = Game.create!(@attr)
        @home.favorite_wins.should == 1
      end

      it "returns this season's played games" do
        @game = Game.create!(@attr)
        @home.played_games[0].id.should == @game.id
      end
     
      it "returns upcoming games" do
        @game = Game.create!(@attr.merge(:gamedate => DateTime.current + 2))
        @home.upcoming_games[0].id.should == @game.id
      end 

      it "ignores last season's games" do
        @game = Game.create!(@attr.merge(:season => "2010-2011"))
        @home.games.count.should == 0
      end
    end

  end


end
