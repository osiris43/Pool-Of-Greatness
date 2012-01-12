require 'spec_helper'

describe NbaConference do
  before(:each) do
    @attr = {:name => "My conference"}
  end

  it "is created with the correct attributes" do
    conf = NbaConference.new(@attr)
    conf.should_not be_nil
  end

  it "responds to name" do
    conf = NbaConference.new(@attr)
    conf.should respond_to(:name)
  end
end
