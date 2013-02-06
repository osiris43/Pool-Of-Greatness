require 'spec_helper'

describe OscarNominee do
  def new_nominee(attributes = {})
    attributes[:nominee] ||= 'Tom Cruise'
    OscarNominee.new(attributes)
  end

  it "should be valid" do
    new_nominee.should be_valid
  end

  it "should require nominee name" do
    new_nominee(:nominee => '').should have(1).error_on(:nominee)
  end

  it "should validate uniqueness of name" do
    new_nominee(:nominee => 'Kate Beckinsale').save!
    new_nominee(:nominee => 'Kate Beckinsale').should have(1).error_on(:nominee)
  end
end
