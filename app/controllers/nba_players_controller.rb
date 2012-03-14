class NbaPlayersController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :find]
  before_filter :admin_user, :except => [:index, :show, :find]
  
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

  def edit
    @title = "Edit player"
    @player = NbaPlayer.find(params[:id])
  end

  def update
    @player = NbaPlayer.find(params[:id])
    if @player.update_attributes(params[:nba_player])
      flash[:success] = "Player updated."
      redirect_to @player
    else
      @title = "Edit player"
      render 'edit'
    end
  end

  def show
    @player= NbaPlayer.find(params[:id])
    @title = @player.display_name
    
  end

  def scrape_all
    parser = NbaPlayerScraper.new
    parser.scrape_all_players
    
    respond_to do |format|
      format.html { redirect_to nba_players_path,
                    :notice => "Players imported"}
    end 

  end

  def find
  end

  def search
    @players = NbaPlayer.where("lastname = ?", params[:player_name]).all
  end

  private
    def admin_user
      redirect_to(current_user) unless current_user.admin?
    end


end
