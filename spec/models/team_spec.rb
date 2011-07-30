require 'spec_helper'

describe Team do
  before(:each) do
    @attr = {:city => "Dallas", :mascot => "Cowboys" }
  end
  it "has a display name" do
    team = Team.create(@attr)
    team.display_name == "Dallas Cowboys" 
  end
end
