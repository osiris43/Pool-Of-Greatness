require 'spec_helper'

describe PoolTemplate do
  before(:each) do
    @attr = { :name => "Template name", :description => "Template description" }
  end

  it "creates a PoolTemplate with the correct attributes" do
    PoolTemplate.create!(@attr)
  end
end
