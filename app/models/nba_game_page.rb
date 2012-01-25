require 'rubygems'
require 'hpricot'
require 'open-uri'

class NbaGamePage 
  def initialize(url)
    @doc = open(url) {|f| Hpricot(f)}
  end 

  def boxscore
    NbaHtmlBoxscore.new(@doc) 
  end
end
