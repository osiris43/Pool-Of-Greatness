require 'spec_helper'

describe NbaStatImportErrorsController do
  render_views

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end

    it "requires logged in user" do
      delete :destroy_all
      response.should redirect_to(login_path)
    end

    it "requires admin user" do
      @controller.stubs(:current_user).returns(@user)
      delete :destroy_all
      flash[:alert].should =~ /You are not authorized/i
    end

    describe 'success' do
      before(:each) do
        @user = Factory(:user, :admin => true)
        @controller.stubs(:current_user).returns(@user)
        @error = Factory(:nba_stat_import_error)
      end

      it "destroys all import errors" do
        lambda do
          delete :destroy_all
        end.should change(NbaStatImportError, :count).by(-1)
      end
    end
  end

  describe "GET 'show'" do
    describe 'failure' do
      it "requires login" do
        get 'show'
        response.should redirect_to(login_path)
      end

      it "requires admin" do
        @user = Factory(:user)
        @controller.stubs(:current_user).returns(@user)
        
        get 'show'
        flash[:alert].should =~ /You are not authorized/i
      end
    end

    describe 'success' do
      before(:each) do
        @user = Factory(:user, :admin => true)
        @controller.stubs(:current_user).returns(@user)
        @error = Factory(:nba_stat_import_error)
      end

      it "is be successful" do
        get 'show'
        response.should be_success
      end

      it "lists the player from any errors" do
        get 'show'
        response.should have_selector("td", :content => "Mo Cheeks") 
      end

      it "lists the href from any errors" do
        get 'show'
        response.should have_selector("a", :href => "http://www.nba.com/player_file/mo_cheeks.html",
                                      :content => "Game Link")
      end

      it "has a delete all link" do
        get 'show'
        response.should have_selector("a", :href => destroy_all_nba_stat_import_errors_path,
                                      :content => "Delete All")
      end
    end
  end
end
