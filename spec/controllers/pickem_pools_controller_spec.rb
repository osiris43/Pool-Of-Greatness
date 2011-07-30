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

    end

  end

  describe "POST 'update'" do
    before(:each) do
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
      session[:pool_id] = Factory(:pool).id 
    end

    it "adds the number of games to the config" do
      lambda do
        post :update, {:number_of_games => '1' } 
      end.should change(PoolConfig, :count).by(1)
    end

    it "adds college config to table" do
      lambda do
        post :update, { :college => '1' } 
      end.should change(PoolConfig, :count).by(1)
    end

    it "adds pro config to the table" do
      lambda do
        post :update, {:pro => "1"}
      end.should change(PoolConfig, :count).by(1)
    end

  end

  describe "GET 'home'" do
    describe 'success' do
      before(:each) do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pool)
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
        response.should have_selector("a", :href => pickem_home_path ,
                                           :content => "Pool Home")
      end

      it "has an admin link for the correct user" do
        @admin = Factory(:user, :username => "adminuser", :email => "test1@test.com", :admin => true)

        @controller.stubs(:current_user).returns(@admin)
        get 'home', :pool => @pool
        response.should have_selector("a", :href => '#',
                                           :content => 'Pool Admin')
      end

      it "has a weekly games link" do
        get 'home', :pool => @pool
        response.should have_selector("a", :href => pickem_weeklygames_path,
                                           :content => "Weekly Games" )

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
        @pool = Factory(:pool)
        @season_config = Factory(:pool_config,
                                 :config_value => "2011-2012", 
                                 :config_key => "current_season", 
                                 :pool => @pool) 
        @week_config = Factory(:pool_config,
                               :config_key => "current_week",
                               :config_value => "1",
                               :pool => @pool) 
        session[:pool_id] = @pool.id
        @pickemWeek = Factory(:pickem_week, :pool => @pool, :deadline => DateTime.now - 1)

      end

      it "is successful" do
        get 'view_games'
        response.should be_success
      end

      it "displays current week" do
        get 'view_games'
        response.should have_selector("h2", :content => "Games for Week 1")
      end

      it "displays the current season" do
        get 'view_games'
        response.should have_selector("h2", :content => "2011-2012")
      end

      it "displays a message for past the deadline" do

        get 'view_games'
        response.should have_selector("p", :content => "The deadline has passed")
      end

      describe 'viewing games' do
        before(:each) do
          @away = Factory(:team)
          @home = Factory(:team, :city => "New York", :mascot => "Jets")
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
        @pool = Factory(:pool)
        session[:pool_id] = @pool.id
      end

      describe 'list games' do
        before(:each) do
          @away = Factory(:team)
          @home = Factory(:team, :city => "New York", :mascot => "Jets")
          @game = Factory(:nflgame, :away_team => @away, :home_team => @home)
          @season_config = Factory(:pool_config,
                                 :config_value => "2011-2012", 
                                 :config_key => "current_season", 
                                 :pool => @pool) 
          @week_config = Factory(:pool_config,
                               :config_key => "current_week",
                               :config_value => "1",
                               :pool => @pool) 


        end

        it "lists available games" do
          get 'administer'

          response.should have_selector("td", :content => 'Dallas Cowboys')
          response.should have_selector("td", :content => 'New York Jets')
        end

      end
    end
  end
end
