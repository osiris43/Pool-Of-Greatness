require 'spec_helper'

describe MastersQualifiersController do

  describe "GET 'index'" do
    before(:each) do
      @qualifier = Factory(:masters_qualifier)
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "returns the qualifiers for this year" do
      get 'index'
      assigns(:qualifiers).should eq([@qualifier])
    end
  end

end
