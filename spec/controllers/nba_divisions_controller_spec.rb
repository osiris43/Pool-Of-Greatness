require 'spec_helper'

describe NbaDivisionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "has a name text box" do
      get 'new'
      response.should have_selector("input", :id => "nba_division_name")
    end
    
    it "has a conference dropdown" do
      get 'new'
      response.should have_selector("select", :id => "nba_division_nba_conference_id")
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @conf = Factory(:nba_conference)
      @attr = {:name => "my division", :nba_conference => @conf}
    end

    it "should be successful" do
      lambda do
        post 'create', :nba_division => @attr
      end.should change(NbaDivision, :count).by(1)
    end
  end

end
