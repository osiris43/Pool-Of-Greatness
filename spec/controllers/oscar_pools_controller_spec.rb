require 'spec_helper'

describe OscarPoolsController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
  end

  describe "GET 'index'" do
    describe "requires a logged in user" do
      before(:each) do
        @pool = Factory(:oscar_pool)
      end

      it "requires a logged in user" do
        get 'index', :id => @pool.id
        response.should redirect_to(login_path)
      end
    end

    describe "with logged in user" do
      before(:each) do
        @controller.stubs(:current_user).returns(@user)
        @pool = Factory(:oscar_pool)
      end

      describe "GET 'index'" do
        it "returns http success" do
          get 'index'
          response.should be_success
        end
      end
      describe "GET 'entries'" do
        it "returns http success" do
          get 'entries'
          response.should be_success
        end
      end

      describe "GET 'leaders'" do
        it "returns http success" do
          get 'leaders'
          response.should be_success
        end
      end

      describe "GET 'picks'" do
        it "returns http success" do
          get 'picks'
          response.should be_success
        end
      end
    end

  end
end
