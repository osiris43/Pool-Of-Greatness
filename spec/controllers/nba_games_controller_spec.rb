require 'spec_helper'

describe NbaGamesController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'scrape_all'" do
    it "should be successful" do
      get 'scrape_all'
      response.should be_success
    end
  end

end
