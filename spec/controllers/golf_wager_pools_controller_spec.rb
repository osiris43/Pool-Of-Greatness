require 'spec_helper'

describe GolfWagerPoolsController do
  render_views
  let(:user) {FactoryGirl.create(:user)}
  let(:pool) {FactoryGirl.create(:golf_wager_pool)}
  before(:each) do
    @controller.stubs(:current_user).returns(user)
    pool = Factory(:golf_wager_pool)
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => pool
      response.should be_success
    end
  end

  describe "GET 'pool_admin'" do
    it "should be successful" do
      get "administer", :id => pool
      response.should be_success
    end
  end

  describe "GET 'show_team'" do
    describe 'failure' do
      it 'requires a logged in user' do
        @controller.stubs(:current_user).returns(nil)
        get 'show_team', :id => pool
        response.should_not be_success
      end
    end
    
    describe 'success' do
      before(:each) do
        @masters_tourney = FactoryGirl.create(:masters_tournament)
        @tiger = FactoryGirl.create(:pga_player)
        @masters_tourney.masters_qualifiers.create!(:pga_player => @tiger)
        @masters_pool = FactoryGirl.create(:masters_pool, :golf_wager_pool => pool, :masters_tournament => @masters_tourney)
        user.expects(:find_masters_pool_entry_by_year).returns(nil)
      end
      it 'is successful' do
        get 'show_team', :id => pool
        response.should be_success
      end

      it "has a masters_team section" do
        get 'show_team', :id => pool
        response.should have_selector("div", :id => "masters_team")
      end

      it "displays a message if no team has been selected" do
        get 'show_team', :id => pool
        response.should have_selector("li", :content => "No team selected yet")
      end

      it "shows the qualifiers" do
        get 'show_team', :id => pool
        response.should have_selector("td", :content => "Tiger Woods")
      end
    end 
  end
end
