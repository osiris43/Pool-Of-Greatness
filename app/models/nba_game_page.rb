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

  def scores_by_team(team)
    if(team == 'away')
      team_idx = 0
    else
      team_idx = 2
    end

    away_row = (@doc/'.nbaGIRegul')[0].search('//tr')[team_idx]
    scores = []
    away_row.search('//td').each do |cell|
      scores.push(cell.inner_html.to_i)
    end

    overtime = (@doc/'.nbaGIOT')
    if(!overtime.empty?)
      away_ot = overtime.search('//tr')[team_idx]
      away_ot.search('//td').each do |cell|
        scores.push(cell.inner_html.to_i)
      end
    end

    scores[0..-2]

  end
end
