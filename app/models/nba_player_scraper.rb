class NbaPlayerScraper
  require 'open-uri'

  def scrape_all_players()
    doc = load_document
    players = (doc/".thePlayers")
    players.each do |player|
      if(player['href'] == "#top")
         next
      end

      player_file = open("http://www.nba.com/" + player['href']) { |f| Hpricot(f)}

      p = NbaPlayer.parse_from_html(player_file)
      p.save

    end 
  end

  private 
    def load_document
      open('http://www.nba.com/players') { |f| Hpricot(f)}
    end
end
