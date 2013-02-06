require 'spec_helper'

describe OscarAward do
  def new_award(attributes = {})
    attributes[:description] ||= 'foo'
    OscarAward.new(attributes)
  end

  it "should be valid" do
    new_award.should be_valid
  end

  it "is invalid without a description" do
    new_award(:description => '').should have(1).error_on(:description)
  end

  it "should validate uniqueness of description" do
    new_award(:description => "foo").save!
    new_award(:description => "foo").should have(1).error_on(:description)
  end
end
