require 'spec_helper'

describe NbaGamesController do
 render_views

  before(:each) do
    @game = Factory(:nba_game)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "shows today's date" do
      d = Date.current
      get 'index'
      response.should have_selector("div", :content => d.strftime("%A %B %d, %Y"))
    end

    it "shows today's games" do
      get 'index'
      response.should have_selector("div", :content => "Mavericks")
      response.should have_selector("div", :content => "Celtics")
    end

    it "has a preview button" do
      get 'index'
      response.should have_selector("a", :content => "Preview", 
                                    :href => nba_game_path(@game.id))
    end
  end

  describe "GET 'show'" do
    #it "is successful" do
    #  get :show, :id => @game
    #  response.should be_success
    #end

    #it "shows matchup title" do
    #  get :show, :id => @game
    #  response.should have_selector("h1", :content => "Dallas Mavericks at Boston Celtics")
    #end
  end

end
