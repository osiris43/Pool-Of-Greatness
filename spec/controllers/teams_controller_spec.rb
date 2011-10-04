require 'spec_helper'

describe TeamsController do
  render_views
  describe "GET 'show'" do
    before(:each) do
      @team = Factory(:nflhometeam)
      Factory(:configuration)
    end

    it "should be successful" do
      get 'show', :id => @team
      response.should be_success
    end

    it "has the right title" do
      @team.stubs(:this_weeks_opponent).returns(Team.new)
      get 'show', :id => @team
      response.should have_selector("title", :content => "Dallas Cowboys")
    end

    describe "gambling information" do
      before(:each) do
        @game = Factory(:nflgame)
      end

      it "shows the team's ATS record" do
        get 'show', :id => @game.home_team
        response.should have_selector("td", :content => "1-0-0")
      end

    end
  end
end
