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
end
