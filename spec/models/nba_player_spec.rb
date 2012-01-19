require 'spec_helper'
require 'hpricot'

describe NbaPlayer do
  before(:each) do
    @attr = {:firstname => 'Dirk', :lastname => 'Allen', :position => 'Guard'}
  end

  it "requires a lastname" do
    NbaPlayer.new(@attr.merge(:lastname => '')).should_not be_valid
  end
  
  it "requires a position" do
    NbaPlayer.new(@attr.merge(:position => '')).should_not be_valid
  end
  
  describe "parsing functionality" do
    before(:each) do
      @html = open('spec/models/ray_allen.html') { |f| Hpricot(f)} 
      @team = Factory(:nba_team)
      NbaTeam.expects(:find_by_mascot).returns(@team)
    end


    it "can parse player firstname from html" do
      p = NbaPlayer.parse_from_html(@html)
      p.firstname.should == "Ray"
    end

    it "can parse player lastname from html" do
      p = NbaPlayer.parse_from_html(@html)
      p.lastname.should == "Allen"
    end

    it "can parse player position" do
      p = NbaPlayer.parse_from_html(@html)
      p.position.should == "Guard"
    end

    it "can parse the player's team" do
      p = NbaPlayer.parse_from_html(@html)
      p.nba_team.city.should == @team.city
    end

    describe 'special cases' do
      before(:each) do
        @single_name_html = open('spec/models/nene.html') { |f| Hpricot(f)}
        @long_name = open('spec/models/mbah_a_moute.html') { |f| Hpricot(f)}
      end

      it "parses single name players as last name only" do
        p = NbaPlayer.parse_from_html(@single_name_html)
        p.lastname.should == 'Nene'
        p.firstname.should == ''
      end

      it "parses ridiculous names" do
        p = NbaPlayer.parse_from_html(@long_name)
        p.lastname.should == 'Mbah a Moute'
        p.firstname.should == 'Luc'
      end
    end
  end
end
