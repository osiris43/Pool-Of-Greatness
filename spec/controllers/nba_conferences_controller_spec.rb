require 'spec_helper'

describe NbaConferencesController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "has a name text box" do
      get 'new'
      response.should have_selector("input", :id => "nba_conference_name")
    end
  end

  describe "POST 'create'" do
    before (:each) do
      @attr = {:name => "my conference"}
    end

    it "should be successful" do
      lambda do 
        post :create, :nba_conference => @attr
      end.should change(NbaConference, :count).by(1)
    end
  end

end
