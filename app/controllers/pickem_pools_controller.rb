class PickemPoolsController < ApplicationController
  before_filter :login_required
  before_filter :poolid_required, :except => :home
  
  def configure
    @title = "Configure your pool"
  end

  def update
    logger.debug(params)
    @pool = Pool.find(session[:pool_id])
    add_configuration(@pool)
    redirect_to user_path(current_user)
  end

  def home
    @pool = Pool.find(params[:pool])
    session[:pool_id] = @pool.id
    @title = @pool.name
  end

  def view_games
    @pool = Pool.find(session[:pool_id])
    @season = @pool.pool_configs.where("config_key = ?", "current_season").first
    @week = @pool.pool_configs.where("config_key = ?", "current_week").first
    logger.debug @season
    logger.debug @week
    @gamesHeader = "Games for Week #{@week.config_value}, #{@season.config_value}"
    @current_week = PickemWeek.where("pool_id = ? AND season = ? AND week = ?", 
                                      session[:pool_id],
                                      @season.config_value,
                                      @week.config_value).first

    if DateTime.now > @current_week.deadline
      flash[:notice] = "The deadline has passed"
    end
  end

  def administer
    @pool = Pool.find(session[:pool_id])

    @season = @pool.pool_configs.where("config_key = ?", "current_season").first
    @week = @pool.pool_configs.where("config_key = ?", "current_week").first
    @games = Game.where("season = ? AND week = ?", @season.config_value, @week.config_value)
  end

  private
    def poolid_required
      redirect_to user_path(current_user) unless session[:pool_id]
    end

    def add_configuration(pool)
      add_config(@pool, :number_of_games, "number_of_games")
      add_config(@pool, :college, "college")
      add_config(@pool, :pro, "pro")
      # TODO get rid of this hard code
      add_config(@pool, :current_season, "2011-2012")
      add_config(@pool, :current_week, "1")
    end

    def add_config(pool, paramsValue, key)
      if !params[paramsValue]
        return
      end

      @config = pool.pool_configs.create
      @config.config_key = key
      @config.config_value = params[key] 
      @config.save
    end
end
