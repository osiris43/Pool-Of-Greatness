require 'spec_helper'

describe SurvivorPoolsController do
  render_views

  def setup_pool()
    @user = Factory(:user)
    @user.create_account
    @user.sites.create!(:name => 'site name', :description => 'description')
    @user.sites[0].pools.create!(:admin_id => @user.id, :name => "My Survivor Pool", :type => "SurvivorPool")
    @user.sites[0].save
    @user = User.find(@user.id)
    @controller.stubs(:current_user).returns(@user)
    @away = Factory(:nflawayteam)
    @home = Factory(:nflhometeam)
    @game = Factory(:nflgame, :away_team => @away, :home_team => @home)
  end

  describe "GET 'index'" do
    it "should be successful" do
      setup_pool()

      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    before(:each) do
      setup_pool()
    end

    it "has a home link" do
      get :show, :id => @user.sites[0].pools[0].id
      response.should have_selector("a", :href => survivor_pool_path(@user.sites[0].pools[0]),
                                         :content => "Pool Home")
    end

    it "has a picksheet link" do
      get :show, :id => @user.sites[0].pools[0].id
      response.should have_selector("a", :href => viewpicksheet_survivor_pool_path(@user.sites[0].pools[0]),
                                         :content => "Picksheet")
    end

    it "has all teams currently picked for the week" do
      @user.survivor_entries.create!(:team => @away, :game => @game, :week => @game.week, 
                                     :season => @game.season, :pool_id => @user.sites[0].pools[0].id)
      get :show, :id => @user.sites[0].pools[0].id
      response.should have_selector("td", :content => @away.teamname)
      response.should have_selector("td", :content => "1")
    end
  end

  describe "GET 'viewpicksheet'" do
    before(:each) do
      setup_pool()
    end

    it "shows current week games" do
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("td", :content => "Dallas Cowboys")
    end

    it "sets any current pick that exists" do
      @user.survivor_entries.create!(:team => @away, :game => @game, :week => @game.week, :season => @game.season)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :value => @away.id.to_s,
                                             :type => "radio",
                                             :checked => "checked")
    end

    it "is disabled if kickoff has happened" do
      @game.gamedate = DateTime.now - 1
      @game.save
      @game1 = Factory(:nflgame, :away_team => @away, :home_team => @home, :gamedate => DateTime.now + 1)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :id => "teamid_#{@away.id}",
                                    :disabled => "disabled")
    end

    it "disables teams that have previously been picked" do
      @game.gamedate = DateTime.now - 7
      @game.save
      @user.survivor_entries.create!(:team => @away, :game => @game, :week => @game.week, :season => @game.season)
      @game1 = Factory(:nflgame, :away_team => @away, :home_team => @home, :week => 2)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :type => "radio",
                                             :id => "teamid_#{@away.id}",
                                             :disabled => "disabled")
    end

    it "is disabled if user has picked a game that is started or over" do
      @user.survivor_entries.create!(:team => @away, :game => @game, :week => @game.week, :season => @game.season)
      @game.gamedate = DateTime.now - 1
      @game.save
      @game1 = Factory(:nflgame, :away_team => @away, :home_team => @home, :gamedate => DateTime.now + 1)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :name => "commit", 
                                    :disabled => "disabled")
    end
  end

  describe "POST 'makepick'" do
    before(:each) do
      setup_pool()
      @user.survivor_entries.create!(:team => @away, :game => @game, :week => @game.week, :season => @game.season)
    end

    it "updates the existing record" do
      lambda do
        post :makepick, :id => @user.sites[0].pools[0].id, :teamid => @home.id
        response.should redirect_to(survivor_pool_path(@user.sites[0].pools[0]))
      end.should_not change(SurvivorEntry, :count)
    end
  end
end
