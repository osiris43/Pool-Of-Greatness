require 'spec_helper'
require 'hpricot'

describe NbaGameline do
  before(:each) do
    @doc = 'spec/models/gameline.html'
  end

  it "is created" do
    NbaGameline.new(@doc).should_not be_nil 
  end

  it "responds to update_stats" do
    gameline = NbaGameline.new(@doc)
    gameline.should respond_to(:update_stats)
  end

end
