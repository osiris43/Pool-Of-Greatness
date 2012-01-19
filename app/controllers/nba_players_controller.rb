class NbaPlayersController < ApplicationController
  def index
  end

  def scrape_all
    parser = NbaPlayerScraper.new
    parser.scrape_all_players
    
    respond_to do |format|
      format.html { redirect_to nba_players_path,
                    :notice => "Players imported"}
    end 

  end

end
