class NbaPlayerScraper
  require 'open-uri'

  def scrape_all_players()
    doc = load_document
    players = (doc/".thePlayers")
    players.each do |player|
      if(player['href'] == "#top")
         next
      end

      if(NbaPlayer.find_by_player_url(player['href']).nil?)
        player_file = open("http://www.nba.com/" + player['href']) { |f| Hpricot(f)}

        p = NbaPlayer.parse_from_html(player_file, player['href'])
        p.save
      end

    end 
  end

  private 
    def load_document
      open('http://www.nba.com/players') { |f| Hpricot(f)}
    end
end
