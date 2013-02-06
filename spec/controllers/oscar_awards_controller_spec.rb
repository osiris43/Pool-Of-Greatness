require 'spec_helper'

describe OscarAwardsController do
  render_views
  describe "GET 'index'" do
    before(:each) do
      @award = Factory(:oscar_award)
    end
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    
    it "shows existing awards" do
      OscarAward.stubs(:all).returns([@award])
      get 'index'
      assigns(:awards).should == [@award]
    end
  end

  describe "GET 'show'" do
  end

  describe "GET 'new'" do
    before(:each) do
      @award = Factory(:oscar_award)
    end
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "has a new award" do
      OscarAward.stubs(:new).returns(@award)
      get 'new'
      assigns(:award).should == @award
    end
  end

  describe "GET 'create'" do
  end

  describe "GET 'edit'" do
  end

  describe "GET 'update'" do
  end

end
