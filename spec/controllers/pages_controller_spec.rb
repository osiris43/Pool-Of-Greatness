require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "has the right title" do
      get 'home'
      response.should have_selector("title", 
                                    :content => "Host all your pools in one location")
    end
  end

  describe "GET 'pricing'" do
    it "should be successful" do
      get 'pricing'
      response.should be_success
    end

    it "has the right title" do
      get 'pricing'
      response.should have_selector("title",
                                    :content => "Pricing")
    end
  end

  describe "GET 'features'" do
    it "should be successful" do
      get 'features'
      response.should be_success
    end

    it "has the right title" do
      get 'features'
      response.should have_selector("title",
                                    :content => "Features")

    end
  end

end
