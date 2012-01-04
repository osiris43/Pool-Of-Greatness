require 'spec_helper'

describe ConfidencePick do
  before(:each) do
    @pool = Factory(:confidence_pool)
    @bowl = Factory(:bowl)
    @attr = {:bowl => @bowl, :team => @bowl.favorite, :rank => 1}
  end


  it "is not nil" do
    pick = ConfidencePick.new(@attr)
    pick.should_not be_nil
  end
end
