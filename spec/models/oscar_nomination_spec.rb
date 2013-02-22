require 'spec_helper'

describe OscarNomination do
  def new_nomination(attributes = {})
    attributes[:oscar_award] ||= OscarAward.new(:description => "Best Picture")
    attributes[:oscar_nominee] ||= OscarNominee.new(:nominee => "Tom Cruise")
    attributes[:year] ||= 2012
    OscarNomination.new(attributes)
  end
=begin
  it "should be valid" do
    new_nomination.should be_valid
  end

  describe "when associations are not present" do
    it "should not allow access to oscar_award_id" do
      expect do
        OscarNomination.new(oscar_award_id: 3)
      end
    end
  end
=end
end
