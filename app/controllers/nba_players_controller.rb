class NbaPlayersController < ApplicationController
  def index
  end

  def new
    @player = NbaPlayer.new
  end

  def create
    @player = NbaPlayer.new(params[:nba_player])
    
    respond_to do |format|
      if @player.save
        format.html { redirect_to new_nba_player_path, 
                      :notice => 'Player created'}
      else
        format.html { render :action => "new", 
                      :notice => "Player save failed"}
      end
    end

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
