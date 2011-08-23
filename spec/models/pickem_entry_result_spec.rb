require 'spec_helper'

describe PickemEntryResult do

  it "returns in the correct order based on wins" do
    @entry1 = Factory(:pickem_entry_result)
    @entry2 = Factory(:pickem_entry_result, :won => 11, :lost => 6, :tied => 0, :tiebreak_distance => 9)

    @entries = PickemEntryResult.all
    @entries.should == [@entry2, @entry1]
  end

  it "is in the right order based on tiebreak distance" do
    @entry1 = Factory(:pickem_entry_result)
    @entry2 = Factory(:pickem_entry_result, :tiebreak_distance => 9)
   
    @entries = PickemEntryResult.all
    @entries.should == [@entry2, @entry1]
  end

end
