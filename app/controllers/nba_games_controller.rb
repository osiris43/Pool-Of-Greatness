class NbaGamesController < ApplicationController
  def index
    @title = "Schedule"
    if(!params[:schedule_date].nil?)
      @date = Date.parse(params[:schedule_date])
    else
      @date = Date.current
    end

    @games = NbaGame.where("gamedate = ?", @date).all
  end

  def show
    @game = NbaGame.find(params[:id])
    @title = "#{@game.away_team.abbreviation} v. #{@game.home_team.abbreviation}"
  end

  def scrape

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
