require 'spec_helper'

describe PoolsController do
  render_views

  before(:each) do
    @attr = { :name => "Pool of greatness" }
  end

  describe "GET 'new'" do
    it "must be logged in to access" do
      get 'new'
      response.should redirect_to(login_path)
    end

    it "must be an admin to access" do
      @user = Factory(:user) 
      @controller.stubs(:current_user).returns(@user)
      post :create, :pool => @attr
      response.should redirect_to(@user)
    end
  end

  describe "POST 'create'" do
    it "adds an entry to poolusers" do
      lambda do
        @user = Factory(:user, :admin => true) 
        @controller.stubs(:current_user).returns(@user)
        post :create, :pool => @attr
      end.should change(Pooluser, :count).by(1)
    end
  end

  describe "POST 'adduser'" do
    it "adds a user to the poolusers" do
      lambda do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pool)
        post :join, :pool => @pool
      end.should change(Pooluser, :count).by(1)
    end
  end

  describe "GET 'find'" do
    it "must be logged in to access" do
      get 'find'
      response.should redirect_to(login_path)
    end

    describe 'search' do
      before(:each) do
        @user = Factory(:user, :admin => true) 
        @controller.stubs(:current_user).returns(@user)
      end

      it "has the right title" do
        get 'find'
        response.should have_selector("title", :content => "Search Pools") 
      end
    end
  end

  describe "POST 'search'" do
    it "must be logged in to access" do
      post :search 
      response.should redirect_to(login_path)
    end

    describe 'success' do
      before(:each) do
        @user = Factory(:user, :admin => true) 
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:pool)
      end

      it "displays a message when no pools are found" do
        post :search, :pool_search => ''
        flash[:notice].should =~ /You must enter a name/i
      end

      it "displays the pools found" do
        post :search, :pool_search => "My Pool"
        response.should have_selector("td", :content => "My Pool")
      end

      it "has a join pool link" do
        post :search, :pool_search => "My Pool"
        response.should have_selector("a", :href => joinpool_path(:pool => @pool),
                                           :content => "Join Pool")
      end
    end
  end
end
