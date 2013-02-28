require 'spec_helper'

describe SurvivorPoolsController do
  render_views

  def setup_pool()
    Factory(:db_config)
    @user = Factory(:user)
    @user.create_account
    @user.sites.create!(:name => 'site name', :description => 'description')
    @user.sites[0].pools.create!(:admin_id => @user.id, :name => "My Survivor Pool", :type => "SurvivorPool")
    @user.sites[0].save
    @user = User.find(@user.id)
    @controller.stubs(:current_user).returns(@user)
    @game = Factory(:nflgame)
    @survivor_session = Factory(:survivor_session)
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
      SurvivorPool.any_instance.stubs(:current_session).returns(@survivor_session)
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
      @user.survivor_entries.create!(:team => @game.away_team, :game => @game, :week => @game.week, 
                                     :season => @game.season, :survivor_session => @survivor_session) 
      get :show, :id => @user.sites[0].pools[0].id
      response.should have_selector("td", :content => @game.away_team.teamname)
      response.should have_selector("td", :content => "1")
    end

    it "has a history link" do
      get :show, :id => @user.sites[0].pools[0]
      response.should have_selector("a", :href => history_survivor_pool_path(@user.sites[0].pools[0]),
                                         :content => "Pool History")
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
      @user.survivor_entries.create!(:team => @game.away_team, :game => @game, :week => @game.week, :season => @game.season)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :value => @game.away_team.id.to_s,
                                             :type => "radio",
                                             :checked => "checked")
    end

    it "is disabled if kickoff has happened" do
      @game.gamedate = DateTime.now - 1
      @game.save
      @game1 = Factory(:nflgame, :gamedate => DateTime.now + 1)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :id => "teamid_#{@game.away_team.id}",
                                    :disabled => "disabled")
    end

    it "disables teams that have previously been picked" do
      @game.gamedate = DateTime.now - 7
      @game.save
      @user.survivor_entries.create!(:team => @game.away_team, 
                                     :game => @game, 
                                     :week => @game.week, 
                                     :season => @game.season, 
                                     :survivor_session => @survivor_session)
      
      @game1 = Factory(:nflgame, :away_team => @game.away_team, :week => 2)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :type => "radio",
                                             :id => "teamid_#{@game.away_team.id}",
                                             :disabled => "disabled")
    end

    it "is disabled if user has picked a game that is started or over" do
      @user.survivor_entries.create!(:team => @game.away_team, :game => @game, :week => @game.week, :season => @game.season)
      @game.gamedate = DateTime.now - 1
      @game.save
      @game1 = Factory(:nflgame, :away_team => @game.away_team, :home_team => @game.home_team, :gamedate => DateTime.now + 1)
      get :viewpicksheet, :id => @user.sites[0].pools[0].id
      response.should have_selector("input", :name => "commit", 
                                    :disabled => "disabled")
    end
  end

  describe "POST 'makepick'" do
    before(:each) do
      setup_pool()
      @user.survivor_entries.create!(:team => @game.away_team, :game => @game, :week => @game.week, :season => @game.season)
    end

    it "updates the existing record" do
      lambda do
        post :makepick, :id => @user.sites[0].pools[0].id, :teamid => @game.home_team.id
        response.should redirect_to(survivor_pool_path(@user.sites[0].pools[0]))
      end.should_not change(SurvivorEntry, :count)
    end
  end

  describe "GET 'standings'" do
    before(:each) do
      setup_pool()
    end

    it "shows results from week 1" do
      @user.survivor_entries.create!(:team => @game.away_team, 
                                     :game => @game,
                                     :week => @game.week, 
                                     :season => @game.season, 
                                     :survivor_session => @survivor_session)
      pool = @user.sites[0].pools[0]
      SurvivorPool.expects(:find).with(pool.id.to_s).returns(pool)
      get :standings, :id => @user.sites[0].pools[0].id
      response.should have_selector(:td, :content => "Brett Bim")
      response.should have_selector(:td, :content => "NYJ")
    end
  end

  describe "GET 'history'" do
    before(:each) do
      @user = Factory(:user)
      @controller.stubs(:current_user).returns(@user)
      @session = Factory(:survivor_session)
      Factory(:configuration)
      @game = Factory(:nflgame)
      SurvivorPool.any_instance.stubs(:current_week).returns(6)
    end

    it "has a yearly summary section" do
      get :history, :id => @session.pool
      response.should have_selector(:div, :class => "yearly_summary")
    end
  end
end
