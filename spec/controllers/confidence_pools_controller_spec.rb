require 'spec_helper'

describe ConfidencePoolsController do
  render_views
  
  before(:each) do
    @controller.stubs(:current_user).returns(User.first)
    @pool = Factory(:confidence_pool)
  end
  it "is successful" do
    get 'show', :id => @pool 
    response.should be_successful
  end

  it "has a link to today's games" do
    get "show", :id => @pool
    response.should have_selector("a", :href => currentgames_confidence_pool_path(@pool),
                                       :content => "Current Games") 
  end

  describe 'current games' do
    it "has the correct title" do
      get "currentgames", :id => @pool
      response.should have_selector("title", :content => "Current Games")
    end
  end
end
