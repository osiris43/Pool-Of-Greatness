require 'spec_helper'

describe NbaPlayersController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'find'" do
    describe 'success' do
      it 'is successful' do
        get 'find'
        response.should be_success
      end

      it "has a search box" do
        get 'find'
        response.should have_selector("input", :id => "player_name")
      end
    end
  end
end
