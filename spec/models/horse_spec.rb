require 'spec_helper'

describe Horse do
  before(:each) do
    @attr = {:name => "Secretariat"}
  end

  it "is created" do
    Horse.new(@attr).should be_valid
  end

  it "requires a name" do
    Horse.new(@attr.merge(:name => "")).should_not be_valid
  end

  it "responds to kentucky derby" do
    @horse = Horse.new(@attr)
    @horse.should respond_to(:kentucky_derby)
  end

  it "responds to opening odds" do
    @horse = Horse.new(@attr)
    @horse.should respond_to(:opening_odds)
  end
end
