require 'spec_helper'
require 'date'

describe PickemPoolsController do
  render_views
  before(:each) do
    @user = Factory(:user)
  end

  describe "GET 'configure'" do
    describe 'failure' do
      before(:each) do
        @pool = Factory(:pickem_pool)
      end
      it "requires a logged in user" do
        get 'configure', :id => @pool.id
        response.should redirect_to(login_path)
      end
    end
    
    describe 'success' do
      before(:each) do
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
      end


      it "should be successful" do
        get 'configure', :id => @pool.id
        response.should be_success
      end

      it "has the right title" do
        get 'configure', :id => @pool.id
        response.should have_selector("title", :content => "Configure your pool")
      end

      it "has a number of games text box" do
        get 'configure', :id => @pool.id
        response.should have_selector("input", :id => "number_of_games")
      end

      it "has a include college check box" do
        get 'configure', :id => @pool.id
        response.should have_selector("input", :id => "college")
      end

      it "has an include pro check box" do
        get 'configure', :id => @pool.id
        response.should have_selector("input", :id => "pro")
      end

      it "has a weekly fee text box" do
        get 'configure', :id => @pool.id
        response.should have_selector("input", :id => "weekly_fee")
      end

    end

  end

  describe "GET 'home'" do
    describe 'success' do
      before(:each) do
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
      end

      it "should be successful" do
        get 'home', :id => @pool.id
        response.should be_success
      end

      it "has the right title" do
        get 'home', :id => @pool.id
        response.should have_selector("title", :content => "My Pool")
      end

      it "has a pool home link" do
        get 'home', :id => @pool.id
        response.should have_selector("a", :href => home_pickem_pool_path(@pool) ,
                                           :content => "Pool Home")
      end

      describe "admin functions" do
        before(:each) do
          @admin = Factory(:user, :username => "adminuser", :email => "test1@test.com", :admin => true)
          @pool1 = Factory(:pickem_pool, :admin_id => @admin.id)
          
          @controller.stubs(:current_user).returns(@admin)
        end

        it "has an admin link for the correct user" do
          get 'home', :id => @pool1.id
          response.should have_selector("a", :href => administer_pickem_pool_path(@pool1),
                                             :content => 'Pool Admin')
        end

        it "has an upgrade pool to current year for admin with last year" do
          get 'home', :id => @pool1.id
          response.should have_selector("div", :id => "upgrade_pool")
        end
      end


      it "has a weekly games link" do
        get 'home', :id => @pool.id
        response.should have_selector("a", :href => view_games_pickem_pool_path(@pool),
                                           :content => "Weekly Games" )

      end

      it "has a view all picks link" do
        get "home", :id => @pool.id
        response.should have_selector("a", :href => view_allgames_pickem_pool_path(@pool),
                                           :content => "View All Picks")
      end

      describe "recent activity" do
        before(:each) do
          @user.create_account
        end

        it "displays a recent activity section" do
          @user.account.transactions.create!(:amount => -12.00)
          get "home", :id => @pool.id
          response.should have_selector("h2", :content => "Recent Account Activity")
        end

        it "displays a no activity message if none exists" do
          get "home", :id => @pool.id
          response.should have_selector("h2", :content => "No account activity")
        end

        it "displays a record for recent activity" do
          @user.account.transactions.create!(:pooltype => 'Pickem', :poolname => @pool.name, 
                                             :amount => 12, 
                                             :description => "Fee for week 1",
                                             :season => @pool.current_season)
          get "home", :id => @pool.id
          response.should have_selector("td", :content => "Fee for week 1")
        end
      end

    end
  end

  describe "POST 'updatepool'" do
    before(:each) do
      @controller.stubs(:current_user).returns(@user)
      @pool = Factory(:pickem_pool)
    end

    #it "should be successful" do
    #  post 'updatepool', :id => @pool.id
    #  response.should be_success
    #end
  end

  describe "GET 'view_games'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'view_games', :id => 1
        response.should_not be_success
      end
    end
   
    describe "success" do
      before(:each) do
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
        @pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)
      end

      it "is successful" do
        get 'view_games', :id => @pool.id
        response.should be_success
      end

      it "displays current week" do
        get 'view_games', :id => @pool.id
        response.should have_selector("h2", :content => "Games for Week 1")
      end

      it "displays the current season" do
        get 'view_games', :id => @pool.id
        response.should have_selector("h2", :content => "2011-2012")
      end

      it "displays a message for past the deadline" do
        @pickemWeek.deadline = DateTime.now - 1
        @pickemWeek.save
        get 'view_games', :id => @pool.id
        response.should redirect_to(home_pickem_pool_path(@pool))
      end


      describe 'viewing games' do
        before(:each) do
          @game = Factory(:nflgame)
          pick = Factory(:pickem_pick, :game => @game)
          @pickemWeek.pickem_games.create!(:game_id => @game.id)
        end
  
        it "has the teams listed" do
          @pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)
          get 'view_games', :id => @pool.id
          response.should have_selector("td", :content => "Dallas Cowboys")
        end

        it 'has a link to team pages' do
          get 'view_games', :id => @pool.id
          response.should have_selector("a", :content => "at Dallas Cowboys",
                                             :href => team_path(@game.home_team.id))
        end

      end 
    end
  end

  describe "GET 'administer'" do
    describe 'success' do
      before(:each)do
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
      end

      describe 'list games' do
        before(:each) do
          @away = Factory(:team)
          @home = Factory(:team, :teamname => "New York Jets" ) 
          @game = Factory(:nflgame, :away_team => @away, :home_team => @home, :type => 'Nflgame')
          pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)
          pickem_game = Factory(:pickem_game, :game => @game, :pickem_week => pickemWeek)
          pickemWeek.pickem_games << pickem_game
          pickemWeek.save
          
        end


        it "has a 'modify config' section" do
          get 'administer', :id => @pool.id
          response.should have_selector("h2", :content => "Modify Pool Configuration")
        end

      end
    end
  end

  describe "GET 'view_allgames'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'view_allgames', :id => 1
        response.should_not be_success
      end

    end

    describe 'success' do
      before(:each) do
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pickem_pool)
      end

      it "displays a message if the deadline hasn't passed" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now + 1)
        get 'view_allgames', :id => @pool.id
        flash[:notice].should =~ /deadline has not passed/i
      end

      it "displays a message if no games exist" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        get "view_allgames", :id => @pool.id
        flash[:notice].should =~ /no games for this week/i
      end

      it "shows the teams row" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        game = Factory(:nflgame, :away_team => Factory(:nflawayteam), :home_team => Factory(:nflhometeam))
        pickem_game = Factory(:pickem_game, :game => game, :pickem_week => pickemWeek)
        entry = Factory(:pickem_pick)

        get "view_allgames", :id => @pool.id
        response.should have_selector("td", :content => "NYJ")
      end

      it "shows the user pick" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        pickemWeek.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 43.5) 
        game = Factory(:nflgame, :away_team => Factory(:nflawayteam), :home_team => Factory(:nflhometeam))
        pickem_game = Factory(:pickem_game, :game => game, :pickem_week => pickemWeek)

        get "view_allgames", :id => @pool.id
        response.should have_selector("td", :content => "Brett Bim")
      end

      it "shows the player's picks" do
        pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
        entry = pickemWeek.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 43.5) 
        team = Factory(:nflawayteam)
        game = Factory(:nflgame, :away_team => team, :home_team => Factory(:nflhometeam))
        entry.pickem_picks.create!(:game => game, :team => team)
        pickem_game = Factory(:pickem_game, :game => game, :pickem_week => pickemWeek)

        get "view_allgames", :id => @pool.id
        response.should have_selector("td", :content => "NYJ")
      end
    end
  end

  describe "GET 'show_results'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'show_results', :id => 1
        response.should_not be_success
      end

    end

    describe 'success' do
      before(:each) do
        setup_pool_entries
      end

      it "has the right title" do
        get 'show_results', :id => @pool.id
        response.should have_selector("title", :content => "Weekly Results")
      end

      it "has first place listed" do
        get "show_results", :id => @pool.id
        response.should have_selector("span", :content => "Brett Bim")
      end

      it "has DAL listed" do
        get "show_results", :id => @pool.id
        response.should have_selector("span", :content => "Tom G")
      end
    end
  end

  describe "GET 'view_poolstats'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'viewstats', :id => 1
        response.should_not be_success
      end
    end

    describe 'success' do
      before(:each) do
        setup_pool_entries
      end

      it "has the right title" do
        get 'viewstats', :id => @pool.id
        response.should have_selector("title", :content => "Season Statistics")
      end
    end
    
  end

  def setup_pool_entries()
    user1 = Factory(:user, :email => 'test1@test.com', :name => "Damon Polk", :username => "damon")
    user2 = Factory(:user, :email => 'test2@test.com', :name => "Alex T", :username => "alex")
    user3 = Factory(:user, :email => 'test3@test.com', :name => "Tom G", :username => "tom")

    @controller.stubs(:current_user).returns(@user)
    @pool = Factory(:pickem_pool)
    session[:pool_id] = @pool.id
    @pool.pickem_rules.create(:config_key => "current_season", :config_value => "2011-2012")
    @pool.pickem_rules.create(:config_key => "current_week", :config_value => "1")
    @pickemWeek = Factory(:pickem_week, :pickem_pool => @pool, :deadline => DateTime.now - 1)
    @entry = @pickemWeek.pickem_week_entries.create!(:user => @user, :mondaynighttotal => 43.5) 
    @entry.create_pickem_entry_result(:won => 3, :lost => 0, :tied => 0, :pickem_week_id => @pickemWeek.id)
    entry1 = @pickemWeek.pickem_week_entries.create!(:user => user1, :mondaynighttotal => 44)
    entry1.create_pickem_entry_result(:won => 2, :lost => 1, :tied => 0, :pickem_week_id => @pickemWeek.id)
    entry2 = @pickemWeek.pickem_week_entries.create!(:user => user2, :mondaynighttotal => 44)
    entry2.create_pickem_entry_result(:won => 1, :lost => 2, :tied => 0, :pickem_week_id => @pickemWeek.id)
    entry3 = @pickemWeek.pickem_week_entries.create!(:user => user3, :mondaynighttotal => 44)
    entry3.create_pickem_entry_result(:won => 0, :lost => 3, :tied => 0, :pickem_week_id => @pickemWeek.id)
    Factory(:configuration)

  end
end
