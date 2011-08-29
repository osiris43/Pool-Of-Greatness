require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  fixtures :all
  render_views

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    User.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    User.any_instance.stubs(:valid?).returns(true)
    post :create
    session['user_id'].should == assigns['user'].id
  end

  it "edit action should redirect when not logged in" do
    get :edit, :id => "ignored"
    response.should redirect_to(login_url)
  end

  it "edit action should render edit template" do
    @controller.stubs(:current_user).returns(User.first)
    get :edit, :id => "ignored"
    response.should render_template(:edit)
  end

  it "update action should redirect when not logged in" do
    put :update, :id => "ignored"
    response.should redirect_to(login_url)
  end

  it "update action should render edit template when user is invalid" do
    @controller.stubs(:current_user).returns(User.first)
    User.any_instance.stubs(:valid?).returns(false)
    put :update, :id => "ignored"
    response.should render_template(:edit)
  end

  it "update action should redirect when user is valid" do
    @controller.stubs(:current_user).returns(User.first)
    User.any_instance.stubs(:valid?).returns(true)
    put :update, :id => "ignored"
    response.should redirect_to(root_url)
  end

  describe "GET 'show'" do
    describe "non-logged in user" do
      it "fails for a non logged in user" do
        get :show, :id => 1
        response.should redirect_to(login_path)
      end
    end

    describe "logged in user" do
      before(:each) do
        @user = User.first
        @user.create_account
        @controller.stubs(:current_user).returns(@user)
      end

      it "shows logged in user" do
        get :show, :id => @user 
        response.should have_selector("title", :content => @user.username)
      end


      describe "showing participating pools" do
        before(:each) do
          @pool = Factory(:pickem_pool)
          @pool.poolusers.create(:user_id => @user.id)
        end

      end

      describe "account activity" do
        before(:each) do
          @user.account.transactions.create!(:pooltype => "Pickem", 
                                             :poolname => "Pool of Greatness",
                                             :amount => -12,
                                             :description => "Fee for week 1")
        end
        it "has account activity section" do
          get :show, :id => @user
          response.should have_selector("div", :id => "account_activity")
        end

        it "shows the current balance" do
          get :show, :id => @user
          response.should have_selector("span", :content => "-$12.00")
        end

        it "shows the last 10 transactions" do
          get :show, :id => @user
          response.should have_selector("td", :content => "Fee for week 1")
        end
      end
    end
  end
end
