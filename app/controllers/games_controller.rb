class GamesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required

  respond_to :html, :xml

  def index
    @title = "All Games"
  end

  def find
    @title = "Games Found"
    @games = Game.where("gamedate between ? AND ?", params[:begin_date], params[:end_date])
    logger.debug "Found #{@games.count} games"
    respond_with(@games)
  end

  def update_individual
    @games = Game.update(params[:games].keys, params[:games].values).reject { |g| g.errors.empty?}
    flash[:notice] = "Games updated"

    redirect_to user_path(current_user)
  end

  def new
    @title = "Create a new game"
    @game = Game.new
  end

  def create
    if params[:game][:type] == 'Ncaagame'
      @game = Ncaagame.new(params[:game])
    else
      @game = Nflgame.new(params[:game])
    end
     
    if @game.save
      redirect_to games_path, :notice => "Game(s) created"
    else
      render :action => 'new'
    end

  end

  def edit
    @game = Game.find(params[:id]) 
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      flash[:success] = "Game updated"
      redirect_to @game
    else
      @title = "Edit game"
      render 'edit'
    end
     
  end

  def show
    @game = Game.find(params[:id]) 
  end
 
  def parse_college_scores
    parser = GamesParser.new
    parser.parse_ncaa_scores(params[:season], '2', params[:week])
    flash[:success] = "Done with NCAA..."
    redirect_to games_path
  end 

  def parse_pro_scores
    parser = GamesParser.new
    parser.parse_nfl_scores(params[:season], '2', params[:week])
    flash[:success] = "Done with NFL..."
    redirect_to games_path
  end 

  def score_pickem
    pools = PickemPool.all
    pools.each do |pool|
      week = PickemWeek.get_current_week(pool.id)
      week.score
      week.update_accounting
      pool.pickem_weeks.create!(:season => pool.current_season,
                                :week => pool.current_week, 
                                :deadline => week.deadline + 7.days)
    end
    flash[:notice] = "Games updated"
    
    redirect_to games_path 

  end

  private
    def admin_required
      redirect_to user_path(current_user) unless current_user.admin?
    end
end
