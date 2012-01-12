require 'spec_helper'

describe NbaTeamsController do
  render_views 
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "has a city text box" do
      get 'new'
      response.should have_selector("input", :id => "nba_team_city")
    end

    it "has a mascot text box" do
      get 'new'
      response.should have_selector("input", :id => "nba_team_mascot")
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @div = Factory(:nba_division)
      @attr = {:city => "Dallas", :mascot => "Mavericks", :abbreviation => "DAL", :nba_division => @div}
    end 
    it "should be successful" do
      lambda do
        post :create, :nba_team => @attr
      end.should change(NbaTeam, :count).by(1)
    end
  end

end
