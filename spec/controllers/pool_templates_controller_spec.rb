require 'spec_helper'

describe PoolTemplatesController do
  before(:each) do
    @user = Factory(:user, :admin => true)
    @controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

end
