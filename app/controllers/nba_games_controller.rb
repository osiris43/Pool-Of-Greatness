class NbaGamesController < ApplicationController
  def index
  end

  def scrape_all
    parser = NbaSeasonParser.new
    parser.parse_by_date_range(params[:begin_date], params[:end_date])
    
    respond_to do |format|
      format.html { redirect_to nba_games_path,
                    :notice => "Games imported"}
    end 

  end

end
