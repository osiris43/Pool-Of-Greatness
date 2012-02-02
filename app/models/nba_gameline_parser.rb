require 'hpricot'

class NbaGamelineParser
  attr_reader :gameline_doc 

  def initialize(gl_filelocation=nil)
    if(gl_filelocation.nil?)
      gl_filelocation = get_location
    end

    @gameline_doc = open(gl_filelocation) {|f| Hpricot(f)}
  end

  def games
    (@gameline_doc/'.nbaMnStatsFtr')
  end

  def get_abbreviation(game, team)
    href= game.search('a')[0]['href']

    if(team == "away")
      return href.split('/')[3][0..2]
    else
      return href.split('/')[3][3..5]
    end
  end

  def get_game_href(game)
    game.search('a')[0]['href']
  end

  def get_gamedate(game)
    Date.parse(get_game_href(game).split('/')[2])
  end


  private 
    def get_location
      schedule_date = Date.current - 1

      "http://www.nba.com/gameline/#{schedule_date.strftime('%Y%m%d')}"
    end
end
