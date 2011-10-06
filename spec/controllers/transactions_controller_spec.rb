require 'spec_helper'

describe TransactionsController do
  render_views
  describe "GET 'newtransaction'" do
    before(:each) do
      @attr = {:name => "my site", :description => 'site description'}
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
      @site = Site.create!(@attr)
      @user.sites<<(@site)
      @site.pools<<(Factory(:pickem_pool))
    end
    
    it "has the right title" do
      get 'new', :site_id => @site
      response.should have_selector("title", :content => "Add a transaction")
    end

    it "has a select box with the users" do
      get 'new', :site_id => @site
      response.should have_selector("option", :content => "Brett Bim")
    end

    it "has a select box with the site's pools" do
      get 'new', :site_id => @site
      response.should have_selector("option", :content => "My Pool")
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attr = {:name => "my site", :description => 'site description'}
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
      @site = Site.create!(@attr)
      @user.sites<<(@site)
      @site.pools.create!(:name => "My Pool", :type => "PickemPool", :admin_id => @user.id)
      @params = {:user => {:id => @user.id}, 
        :pool => {:id => @site.pools[0].id}, 
        :amount => -12, 
        :description => "description"}

      @user.account.stubs(:id).returns(1)
    end

    it "saves the transaction" do
      lambda do
        post 'create', :site_id => @site, :pool => {:id => @site.pools[0].id},
          :user => {:id => @user.id}, :mount => -12, :description => "description"
        response.should redirect_to(site_transactions_path(@site))
      end.should change(Transaction, :count).by(1)
    end
  end
end

