require 'spec_helper'

describe PgaPlayer do
  before(:each) do
    @attr = {:name => "Tiger Woods"}
  end

  it "requires a name attribute" do
    PgaPlayer.new(@attr.merge(:name => "")).should_not be_valid
  end
end
