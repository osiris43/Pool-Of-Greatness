require 'spec_helper'

describe SitesController do
  render_views

  describe "GET 'new'" do
    describe 'failure' do
      it "requires a logged in user" do
        get 'new'
        response.should redirect_to(login_path)
      end
    end
    
    describe 'success' do
      before(:each) do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
      end
      
      it "should be successful" do
        get 'new'
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attr = {:name => "my site", :description => 'site description'}
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
    end

    it 'creates a site' do
      lambda do
        post :create, :site => @attr
        response.should redirect_to(user_path(@user))
      end.should change(Site, :count).by(1)
    end

    it "adds a relation to the current user" do
      post :create, :site => @attr
      @user.sites.count.should == 1
    end
  end

  describe "PUT 'join'" do
    before(:each) do
      @attr = {:name => "my site", :description => 'site description'}
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
      @site = Site.create!(@attr)
    end
    
    it "adds current user to the site" do
      get :join, :id => @site.id
      response.should redirect_to(user_path(@user))
      @user.sites.count.should == 1
    end
  end

  describe "POST 'add_pool'" do
    before(:each) do
      @attr = {:name => "my site", :description => 'site description'}

      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
      @site = Site.create!(@attr)
      @poolattr = {:poolname => "my site", :pool => {:type => 'PickemPool'}}

    end

    it "adds the site to the user's sites" do
      post :add_pool, :id => @site.id, :poolname => "my name",:current_week => 1, :current_season => '2011-2012',   
        :pool => {:type => 'PickemPool'} 
      @site.pools.count.should == 1
    end

    it "adds the number of games to the config" do
      lambda do
        post :add_pool, :id => @site.id, :number_of_games => '1',:current_week => 1, 
          :current_season => "2011-2012", :pool => {:type => 'PickemPool'}  
      end.should change(PickemRule, :count).by(3)
    end

    it "adds college config to table" do
      lambda do
        post :add_pool, :id => @site.id, :college => '1',
         :current_week => 1, :current_season => "2011-2012",  :pool => {:type => 'PickemPool'}  
      end.should change(PickemRule, :count).by(3)
    end

    it "adds pro config to the table" do
      lambda do
        post :add_pool, :id => @site.id, :pro => "1", :current_week => 1, :current_season => '2011-2012',
          :pool => {:type => 'PickemPool'}
      end.should change(PickemRule, :count).by(3)
    end

    it "adds weekly fee to table" do
      lambda do
        post :add_pool, :id => @site.id, :weekly_fee => "10", :current_week => 1, :current_season => '2011-2012',    
          :pool => {:type => 'PickemPool'}

      end.should change(PickemRule, :count).by(3)
    end
  end
end
