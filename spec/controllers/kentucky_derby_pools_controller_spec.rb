require 'spec_helper'

describe KentuckyDerbyPoolsController do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @pool = Factory(:kentucky_derby_pool)
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
    end

    it "returns http success" do
      get 'show', :id => @pool
      response.should be_success
    end

    it "has the pool name listed" do
      get 'show', :id => @pool
      response.should have_selector("div", :class => "banner_text",
                                    :content => "All The Pretty Horsies")
    end

    it "has a pool home link" do
      get 'show', :id => @pool
      response.should have_selector("a", :href => kentucky_derby_pool_path(@pool),
                                    :content => "Pool Home")
    end

    it "has a The Window Link" do
      get 'show', :id => @pool
      response.should have_selector("a", :href => show_window_kentucky_derby_pool_path(@pool),
                                    :content => "The Window")
    end
  end

  describe "GET 'show_window'" do
    before(:each) do
      @pool = Factory(:kentucky_derby_pool)
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
    end

    it "returns http success" do
      get "show_window", :id => @pool
      response.should be_success
    end

    it "displays a message when no betting window is open" do
      get "show_window", :id => @pool
      response.should have_selector("span") do |message|
        message.should contain(/betting window is not currently open/i)
      end
    end

    
  end
end
