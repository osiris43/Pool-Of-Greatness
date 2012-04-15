require 'spec_helper'

describe AdministrationController do
  render_views
  
  before(:each) do
    @user = Factory(:user, :admin => true)
    @controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "has a create new masters tournament section" do
      get "index"
      response.should have_selector("div", :id => "new_masters_tournament") 
    end

    it "has a masters qualifiers import" do
      get "index"
      response.should have_selector("input", :type => "file", :id => "importfile")
    end
  end

  describe "POST 'create_masters_tournament'" do
    before(:each) do
      @user = Factory(:user, :admin => true)
      @controller.stubs(:current_user).returns(@user)
      @attr = {:year => '2012'}
    end

    describe 'failure' do
      it "does not add a tournament with no year" do
        lambda do
          post :create_masters_tournament, :tournament => @attr.merge(:year => "")
        end.should_not change(MastersTournament, :count)
      end
    end

    describe 'success' do
      it "creates a new tournament" do
        lambda do
          post :create_masters_tournament, :tournament => @attr
        end.should change(MastersTournament, :count).by(1)
      end

      it "has the correct flash message" do
        post :create_masters_tournament, :tournament => @attr
        flash[:success].should =~ /Masters for year 2012 created/i
      end
    end
  end



end
