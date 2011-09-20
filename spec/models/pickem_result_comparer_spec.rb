require 'spec_helper'

describe PickemResultComparer do
  describe "ties" do
    before(:each) do
      @results = []
      result1 = PickemEntryResult.new(:won => 4, :lost => 1, :tied => 1, :tiebreak_distance => 3, :pickem_week_id => 1 )
      result2 = PickemEntryResult.new(:won => 4, :lost => 1, :tied => 1, :tiebreak_distance => 3, :pickem_week_id => 1 )
      result3 = PickemEntryResult.new(:won => 4, :lost => 1, :tied => 1, :tiebreak_distance => 3, :pickem_week_id => 1 )
      result4 = PickemEntryResult.new(:won => 4, :lost => 1, :tied => 1, :tiebreak_distance => 3, :pickem_week_id => 1 )

      @results << result1
      @results << result2
      @results << result3
      @results << result4
    end

    it "has all four in first place" do
      comparer = PickemResultComparer.new(@results)
      comparer.firstplace.count.should == 4
    end

    it "has two second places" do
      @results[1].won = 3
      @results[2].won = 3
      @results[3].won = 2

      comparer = PickemResultComparer.new(@results)
      comparer.secondplace.count.should == 2 
    end

    it "has two third places" do
      @results[1].won = 3
      @results[2].won = 2
      @results[3].won = 2
      comparer = PickemResultComparer.new(@results)
      comparer.thirdplace.count.should == 2 
    end

    it "has 1 firsts and 2 thirds" do
      @results[2].won = 2
      @results[3].won = 2
      comparer = PickemResultComparer.new(@results)
      comparer.firstplace.count.should == 2
      comparer.thirdplace.count.should == 2 

    end
  end
end

