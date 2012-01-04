require 'spec_helper'

describe PossibleOutcome do
  before(:each) do
    @outcome = PossibleOutcome.new({})

  end
  it "is not nil" do
    @outcome.should_not be_nil
  end 

  it "responds to score" do
    @outcome.should respond_to(:score)
  end

  it "responds to won" do
    @outcome.should respond_to(:won)
  end

  describe "scoring" do
    before(:each) do
      @bowl = Factory(:bowl)
      @user = Factory(:user)
      @attr = {:user => @user, :bowl => @bowl, :team => @bowl.favorite, :rank => 1}
      @pick = ConfidencePick.new(@attr)
      @outcome1 = PossibleOutcome.new({@bowl.id => @bowl.favorite.id})
    end

    it "scores a single entry" do
      @outcome1.score([@pick])
      @outcome1.user_by_place(1).should == @user.name 
    end

    it "scores multiple entries" do
      @user1 = Factory(:user, :name => "tom")
      @attr1 = {:user => @user1, :bowl => @bowl, :team => @bowl.underdog, :rank => 1}
      @pick1 = ConfidencePick.new(@attr1)
      @outcome1.score([@pick, @pick1])
      @outcome1.user_by_place(1).should == @user.name 
      @outcome1.user_by_place(2).should == @user1.name
    end
  end
end

