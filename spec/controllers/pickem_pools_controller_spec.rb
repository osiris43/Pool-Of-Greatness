require 'spec_helper'
require 'date'

describe PickemPoolsController do
  render_views

  describe "GET 'configure'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'configure'
        response.should redirect_to(login_path)
      end

      it "requires a pool id in the session" do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        get 'configure'
        response.should redirect_to user_path(@user)
      end

    end
    
    describe 'success' do
      before(:each) do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        session[:pool_id] = "1"
      end


      it "should be successful" do
        get 'configure'
        response.should be_success
      end

      it "has the right title" do
        get 'configure'
        response.should have_selector("title", :content => "Configure your pool")
      end

      it "has a number of games text box" do
        get 'configure'
        response.should have_selector("input", :id => "number_of_games")
      end

      it "has a include college check box" do
        get 'configure'
        response.should have_selector("input", :id => "college")
      end

      it "has an include pro check box" do
        get 'configure'
        response.should have_selector("input", :id => "pro")
      end

      it "has a weekly fee text box" do
        get 'configure'
        response.should have_selector("input", :id => "weekly_fee")
      end

    end

  end

  describe "POST 'update'" do
    before(:each) do
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
      session[:pool_id] = Factory(:pickem_pool).id 
    end

    it "adds the number of games to the config" do
      lambda do
        post :update, {:number_of_games => '1' } 
      end.should change(PickemRule, :count).by(1)
    end

    it "adds college config to table" do
      lambda do
        post :update, { :college => '1' } 
      end.should change(PickemRule, :count).by(1)
    end

    it "adds pro config to the table" do
      lambda do
        post :update, {:pro => "1"}
      end.should change(PickemRule, :count).by(1)
    end

    it "adds weekly fee to table" do
      lambda do
        post :update, {:weekly_fee => "10"}
      end.should change(PickemRule, :count).by(1)
    end
  end

  describe "GET 'home'" do
    describe 'success' do
      before(:each) do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
      end

      it "should be successful" do
        get 'home', :pool => @pool
        response.should be_success
      end

      it "has the right title" do
        get 'home', :pool => @pool
        response.should have_selector("title", :content => "My Pool")
      end

      it "has a pool home link" do
        get 'home', :pool => @pool
        response.should have_selector("a", :href => pickem_home_path(:pool => @pool) ,
                                           :content => "Pool Home")
      end

      it "has an admin link for the correct user" do
        @admin = Factory(:user, :username => "adminuser", :email => "test1@test.com", :admin => true)

        @controller.stubs(:current_user).returns(@admin)
        get 'home', :pool => @pool
        response.should have_selector("a", :href => pickem_administer_path,
                                           :content => 'Pool Admin')
      end

      it "has a weekly games link" do
        get 'home', :pool => @pool
        response.should have_selector("a", :href => pickem_weeklygames_path,
                                           :content => "Weekly Games" )

      end

      it "has a view all games link" do
        get "home", :pool => @pool
        response.should have_selector("a", :href => pickem_view_allgames_path,
                                           :content => "View All Games")
      end

      describe "recent activity" do
        before(:each) do
          @user.create_account
        end

        it "displays a recent activity section" do
          get "home", :pool => @pool
          response.should have_selector("div", :class => "recent_activity")
        end

        it "displays a no activity message if none exists" do
          get "home", :pool => @pool
          response.should have_selector("h2", :content => "No recent activity")
        end

        it "displays a record for recent activity" do
          @user.account.transactions.create!(:pooltype => 'Pickem', :poolname => @pool.name, 
                                             :amount => 12, 
                                             :description => "Fee for week 1")
          get "home", :pool => @pool
          response.should have_selector("td", :content => "Fee for week 1")

        end
      end

    end
  end

  describe "GET 'view_games'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'view_games'
        response.should_not be_success
      end
    end
    
    describe "success" do
      before(:each) do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
        @season_config = Factory(:pickem_rule,
                                 :config_value => "2011-2012", 
                                 :config_key => "current_season", 
                                 :pickem_pool => @pool) 
        @week_config = Factory(:pickem_rule,
                               :config_key => "current_week",
                               :config_value => "1",
                               :pickem_pool => @pool) 
        session[:pool_id] = @pool.id
      end

      it "is successful" do
        @pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)

        get 'view_games'
        response.should be_success
      end

      it "displays current week" do
        @pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)
        
        get 'view_games'
        response.should have_selector("h2", :content => "Games for Week 1")
      end

      it "displays the current season" do
        @pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)

        get 'view_games'
        response.should have_selector("h2", :content => "2011-2012")
      end

      it "displays a message for past the deadline" do
        @pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1 )
        get 'view_games'
        response.should redirect_to(pickem_home_path(:pool => @pool))

      end

      describe 'viewing games' do
        before(:each) do
          @away = Factory(:team)
          @home = Factory(:team, :teamname => "New York Jets" ) 
          @game = Factory(:nflgame, :away_team => @away, :home_team => @home)
        end
  
        it "displays the game"

      end 
    end
  end

  describe "GET 'administer'" do
    describe 'failure' do

      it "requires a valid pool id" do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)

        session[:pool_id] = nil
        get 'administer'

        response.should_not be_success
      end

    end
    describe 'success' do
      before(:each)do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
        @pool.pickem_rules.create(:config_key => "current_season", :config_value => "2011-2012")
        @pool.pickem_rules.create(:config_key => "current_week", :config_value => "1")
        @pool.pickem_rules.create(:config_key => "pro", :config_value => "1")
        @pool.pickem_rules.create(:config_key => "college", :config_value => "1")
        session[:pool_id] = @pool.id
      end

      describe 'list games' do
        before(:each) do
          @away = Factory(:team)
          @home = Factory(:team, :teamname => "New York Jets" ) 
          @game = Factory(:nflgame, :away_team => @away, :home_team => @home, :type => 'Nflgame')
          pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)
          pickem_game = Factory(:pickem_game, :game => @game, :pickem_week => pickemWeek)
          
        end


        it "has a 'modify config' section" do
          get 'administer'

          response.should have_selector("h2", :content => "Modify Pool Configuration")
        end

      end
    end
  end

  describe "GET 'view_allgames'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'view_allgames'
        response.should_not be_success
      end

      it "requires a pool " do
        user = Factory(:user)
        @controller.stubs(:current_user).returns(user)
        get 'view_allgames'
        response.should_not be_success
      end
    end

    describe 'success' do
      before(:each) do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
        session[:pool_id] = @pool.id
        @pool.pickem_rules.create(:config_key => "current_season", :config_value => "2011-2012")
        @pool.pickem_rules.create(:config_key => "current_week", :config_value => "1")
      end

      it "displays a message if the deadline hasn't passed" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)
        get 'view_allgames'
        flash[:notice].should =~ /deadline has not passed/i
      end

      it "displays a message if no games exist" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        get "view_allgames"
        flash[:notice].should =~ /no games for this week/i
      end

      it "shows the teams row" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        game = Factory(:nflgame, :away_team => Factory(:nflawayteam), :home_team => Factory(:nflhometeam))
        pickem_game = Factory(:pickem_game, :game => game, :pickem_week => pickemWeek)
        entry = Factory(:pickem_pick, :game => game, :user => @user, :team => Factory(:nflhometeam))

        get "view_allgames"
        response.should have_selector("td", :content => "New York Jets at Dallas Cowboys (-2.0)")
      end

      it "shows the user pick" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        pickemWeek.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 43.5) 
        game = Factory(:nflgame, :away_team => Factory(:nflawayteam), :home_team => Factory(:nflhometeam))
        pickem_game = Factory(:pickem_game, :game => game, :pickem_week => pickemWeek)

        get "view_allgames"
        response.should have_selector("td", :content => "Brett Bim")
      end

      it "shows the player's picks" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        entry = pickemWeek.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 43.5) 
        team = Factory(:nflawayteam)
        game = Factory(:nflgame, :away_team => team, :home_team => Factory(:nflhometeam))
        entry.pickem_picks.create!(:game => game, :team => team)
        pickem_game = Factory(:pickem_game, :game => game, :pickem_week => pickemWeek)

        get "view_allgames"
        response.should have_selector("td", :content => "New York Jets")
      end
    end
  end
end
