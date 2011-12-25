require 'spec_helper'

describe ConfidencePool do
  before(:each) do
    @pool = Factory(:confidence_pool)
    @bowl = Factory(:bowl, :date => DateTime.current)
  end 

  it "gets today's games" do
    @bowls = @pool.get_currentgames
    @bowls[0].should == @bowl
  end
end
