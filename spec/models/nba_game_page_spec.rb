require 'spec_helper'
require 'Hpricot'

describe NbaGamePage do
  before(:each) do
    @url = 'spec/models/single_game.html'
  end 
  
  it 'is created' do
    NbaGamePage.new(@url).should_not be_nil
  end 

  it 'responds to box score' do
    NbaGamePage.new(@url).should respond_to(:boxscore)
  end
end

