require 'spec_helper'

describe Pool do
  def new_pool(attributes = {})
    attributes[:name] ||= 'Pool name'
    attributes[:type] ||= 'PickemPool'
    attributes[:admin_id] ||= 1
    attributes[:active] ||= true
    Pool.new(attributes) 
  end

  it "displays an active status" do
    pool = new_pool
    pool.status.should == "Active"
  end
end
