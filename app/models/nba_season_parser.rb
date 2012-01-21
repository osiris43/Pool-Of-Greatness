require 'date'
require 'open-uri'

class NbaSeasonParser
  def parse_by_date_range(from, to)
    begin_date = Date.parse(from)
    end_date = Date.parse(to)

    (begin_date..end_date).to_a.each do |d|
      url_date = d.strftime("%Y%m%d")
      game_date = d.strftime("%Y-%m-%d")
      doc = open("http://www.nba.com/gameline/" + url_date) { |f| Hpricot(f)}
      games = (doc/'.nbaModOuterBox')
      games.each do |game|
        g = NbaGame.parse_from_html(game, game_date)
        g.save
      end
    end
  end
end
