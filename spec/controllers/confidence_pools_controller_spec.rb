require 'spec_helper'

describe ConfidencePoolsController do
  before(:each) do
    @pool = Factory(:confidence_pool)
  end
  it "is successful" do
    get 'show', :id => @pool 
    response.should be_successful
  end
end
