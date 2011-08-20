class PickemPoolsController < ApplicationController
  before_filter :login_required
  before_filter :poolid_required, :except => :home
  
  def configure
    @title = "Configure your pool"
  end

  def update
    logger.debug(params)
    @pool = PickemPool.find(session[:pool_id])
    add_configuration(@pool)
    redirect_to user_path(current_user)
  end

  def home
    @pool = PickemPool.find(params[:pool])
    session[:pool_id] = @pool.id
    @title = @pool.name
  end

  def view_games
    @current_week = get_current_week

    if DateTime.now > @current_week.deadline
      @pool = PickemPool.find(session[:pool_id])

      flash[:notice] = "The deadline has passed"
      redirect_to(pickem_home_path(:pool => @pool))
    else
      render 'view_games'
    end
  end

  def administer
    @pool = PickemPool.find(session[:pool_id])
    @games = get_weekly_games(@pool.id)
    @current_week = get_current_week
  end

  def create_games
    @current_week = get_current_week

    @games = get_weekly_games(@pool.id)
    includedgames = params[:game_ids].collect {|id| id.to_i} if params[:game_ids]
    @games.each do |game|
      if includedgames.include?(game.id) && !@current_week.pickem_games.find_by_game_id(game.id)
        logger.debug "creating the game"
        @current_week.pickem_games.create!(:game_id => game.id)
      end
    end

    redirect_to(user_path(current_user)) 
  end

  def save_picks
    selectedGames = params.select {|key,value| key =~ /gameid_/ }
    @pool = PickemPool.find(session[:pool_id])
    @current_week = get_current_week
 
   # save the picks 
    @current_week.save_picks(selectedGames, current_user, params[:mnftotal].to_f) 

    # add accounting record
    if current_user.account.nil?
      current_user.create_account
    end

    current_user.account.transactions.create!(:pooltype => 'Pickem', :poolname => @pool.name, 
                                              :amount => 12, 
                                              :description => "Fee for week #{@current_week.week}, season #{@current_week.season}")


    redirect_to(pickem_home_path(:pool => @pool))
  end

  def view_allgames
    @current_week = get_current_week
    
    if DateTime.now < @current_week.deadline
      flash[:notice] = "The deadline has not passed"
      @pool = PickemPool.find(session[:pool_id])

      redirect_to(pickem_home_path(:pool => @pool))
    elsif @current_week.pickem_games.count < 1
      flash[:notice] = "There are no games for this week"
      @pool = PickemPool.find(session[:pool_id])

      redirect_to(pickem_home_path(:pool => @pool))
    else
      render 'view_allgames'
    end
    
  end

  def admin_pick_weekly_games
    @pool = PickemPool.find(session[:pool_id])
    @games = get_weekly_games(@pool.id)
    @current_week = get_current_week

  end

  private
    def get_current_week
      @pool = PickemPool.find(session[:pool_id])
      @season = @pool.pickem_rules.where("config_key = ?", "current_season").first
      @week = @pool.pickem_rules.where("config_key = ?", "current_week").first
      logger.debug @season
      logger.debug @week
      @gamesHeader = "Games for Week #{@week.config_value}, #{@season.config_value}"
      logger.debug "PoolId: #{@pool.id}\tSeason: #{@season.config_value}\tWeek: #{@week.config_value}"
      @current_week = PickemWeek.where("pickem_pool_id = ? AND season = ? AND week = ?", 
                                        session[:pool_id],
                                        @season.config_value,
                                        @week.config_value).first

      return @current_week
    end

    def get_weekly_games(poolId)
      season = @pool.pickem_rules.where("config_key = ?", "current_season").first
      week = @pool.pickem_rules.where("config_key = ?", "current_week").first
      includePro = @pool.pickem_rules.where("config_key = ?", "college").first
      includeCollege = @pool.pickem_rules.where("config_key = ?", "pro").first
      @games = Game.find_by_season_week(season.config_value, week.config_value,
                                      includePro.config_value, includeCollege.config_value)

    end

    def poolid_required
      redirect_to user_path(current_user) unless session[:pool_id]
    end

    def add_configuration(pool)
      add_rule(@pool, :number_of_games, "number_of_games")
      add_rule(@pool, :college, "college")
      add_rule(@pool, :pro, "pro")
      # TODO get rid of this hard code
      add_rule(@pool, :current_season, "current_season")
      add_rule(@pool, :current_week, "current_week")
      add_rule(@pool, :weekly_fee, "weekly_fee")
    end

    def add_rule(pool, paramsValue, key)
      if !params[paramsValue]
        return
      end

      @rule= pool.pickem_rules.create
      @rule.config_key = key
      @rule.config_value = params[key] 
      @rule.save
    end
end
