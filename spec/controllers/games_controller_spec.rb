require 'spec_helper'

describe GamesController do
  render_views
  describe "GET 'index'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'index'
        response.should redirect_to(login_path)
      end

      it "requires a site admin" do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)

        get 'index'
        response.should redirect_to(user_path(@user))
      end
    end
    
    describe 'success' do
      before(:each) do
        @user = Factory(:user, :admin => true)
        @controller.stubs(:current_user).returns(@user)
      end

      it "has the right title" do
        get 'index'
        response.should have_selector("title", :content => "All Games")
      end
    end
  end

  describe "GET 'find'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'find'
        response.should redirect_to(login_path)
      end

      it "requires a site admin" do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)

        get 'find'
        response.should redirect_to(user_path(@user))
      end
    end

    describe 'success' do
      before(:each) do
        @user = Factory(:user, :admin => true)
        @controller.stubs(:current_user).returns(@user)
        @attr = { :begin_date => '2011-08-01', :end_date => '2011-08-09'}
        @away = Factory(:nflawayteam)
        @home = Factory(:nflhometeam)
        @game = Factory(:nflgame, :away_team => @away, :home_team => @home, :gamedate => '2011-08-02')
      end
      
      it "lists the correct games" do
        get 'find', :begin_date => '2011-08-01', :end_date => '2011-08-09' 
        response.should have_selector("td", :content => "Dallas Cowboys")
      end
    end
  end

  describe 'new' do
    before(:each) do
      @user = Factory(:user, :admin => true)
      @controller.stubs(:current_user).returns(@user)
      @away = Factory(:nflawayteam)
      @home = Factory(:nflhometeam)
    end

    it "has the right title" do
      get 'new'
      response.should have_selector("title", :content => "Create a new game")
    end

    it "lists all teams in the away select box" do
      get 'new'
      response.should have_selector("option", :content => "New York Jets")
    end
  end
end
