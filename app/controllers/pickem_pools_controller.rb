class PickemPoolsController < ApplicationController
  before_filter :login_required
  
  def configure
    @title = "Configure your pool"
    @pool = PickemPool.find(params[:id])

  end

  def update
    logger.debug(params)
    @pool = PickemPool.find(params[:id])

    redirect_to user_path(current_user)
  end

  def home
    @pool = PickemPool.find(params[:id])
    @title = @pool.name

    if current_user.account.nil?
      current_user.create_account
    end
    @transactions = current_user.account.transactions.where(:poolname => @pool.name).all(:limit => 10, :order => "created_at DESC")
    @userstats = Userstat.find_by_season(@pool.current_season)[0..2] 
    
  end

  def view_games
    @current_week = get_current_week
    @games = @current_week.pickem_games.joins(:game).order("games.gamedate")
    entry = @current_week.pickem_week_entries.find_by_user_id(current_user.id)
   
    @teamids = []
    if !entry.nil? && !entry.pickem_picks.empty?
      @teamids = entry.pickem_picks.map{ |pick| pick.team_id}
    end

    if DateTime.now > @current_week.deadline
      @pool = PickemPool.find(params[:id])

      flash[:notice] = "The deadline has passed"
      redirect_to(home_pickem_pool_path(@pool))
    else
      render 'view_games'
    end
  end

  def administer
    @pool = PickemPool.find(params[:id])
    @games = get_weekly_games(@pool.id)
    @current_week = get_current_week
    #@tiebreakGame = @current_week.pickem_games.find_by_istiebreaker(true)
    #if @tiebreakGame.nil?
    #  @tiebreakGame = PickemGame.new 
    #end
    @tiebreakGameId = -1
    if !@current_week.pickem_games.find_by_istiebreaker(true).nil?
      @tiebreakGameId = @current_week.pickem_games.find_by_istiebreaker(true).game_id
    end
  end

  def create_games
    @current_week = get_current_week
    @pool = PickemPool.find(params[:id])
    @games = get_weekly_games(@pool.id)
    includedgames = params[:game_ids].collect {|id| id.to_i} if params[:game_ids]
    @games.each do |game|
      if includedgames.include?(game.id) && !@current_week.pickem_games.find_by_game_id(game.id)
        logger.debug "creating the game"
        @current_week.pickem_games.create!(:game_id => game.id, :istiebreaker => game.id == params[:tiebreaker].to_i)
      end
    end

    redirect_to(user_path(current_user)) 
  end

  def save_picks
    selectedGames = params.select {|key,value| key =~ /gameid_/ }
    @pool = PickemPool.find(params[:id])
    @current_week = get_current_week
 
   # save the picks 
    @current_week.save_picks(selectedGames, current_user, params[:mnftotal].to_f) 

    flash[:notice] = "Picks successfully saved"

    redirect_to(home_pickem_pool_path(@pool))
  end

  def view_allgames

    @current_week = get_current_week
    
    if DateTime.now < @current_week.deadline
      flash[:notice] = "The deadline has not passed"
      @pool = PickemPool.find(params[:id])

      redirect_to(home_pickem_pool_path(:pool => @pool))
    elsif @current_week.pickem_games.count < 1
      flash[:notice] = "There are no games for this week"
      @pool = PickemPool.find(params[:id])

      redirect_to(home_pickem_pool_path(:pool => @pool))
    else
      render 'view_allgames'
    end
    
  end

  def admin_pick_weekly_games
    @pool = PickemPool.find(params[:id])
    @games = get_weekly_games(@pool.id)
    @current_week = get_current_week

  end

  def show_results
    @title = "Weekly Results"
    logger.debug "Week Id is #{params[:weekid]}"
    @current_week = get_current_week(params[:weekid])
    @allweeks = get_all_weeks
    #if @current_week.pickem_entry_results.nil? || @current_week.pickem_entry_results.count < 1
    #  @current_week = get_previous_week
    #end
    @results_header = "Results for Week #{@current_week.week}, Season #{@current_week.season}"
  end

  def viewstats 
    @title = "Season Statistics"
    @pool = PickemPool.find(params[:id])
    @userstats = Userstat.find_by_season(@pool.current_season) 
  end

  def modify_accounting
    @title = "Modify Accounting"
    @pool = PickemPool.find(params[:id])
    @users = User.joins(:pickem_week_entries).all
  end

  def view_transactions
    @pool = PickemPool.find(params[:id])
    user = User.find(params[:user][:id])

    @transactions = user.account.transactions
  end

  def update_transactions
    @pool = PickemPool.find(params[:id])
    @transactions = Transaction.update(params[:transactions].keys, params[:transactions].values).reject { |g| g.errors.empty?}

    flash[:notice] = "Successfully updated"
    redirect_to modify_accounting_pickem_pool_path(@pool)
  end
 
  private
    def get_current_week(week=0)
      @pool = PickemPool.find(params[:id])
      @season = @pool.current_season
      if week.nil? || week == 0
        week = @pool.pickem_rules.where("config_key = ?", "current_week").first.config_value
      end
      
      @gamesHeader = "Games for Week #{week}, #{@season}"
      logger.debug "PoolId: #{@pool.id}\tSeason: #{@season}\tWeek: #{week}"
      @current_week = PickemWeek.where("pickem_pool_id = ? AND season = ? AND week = ?", 
                                        params[:id],
                                        @season,
                                        week).first

      return @current_week
    end
    
    def get_all_weeks
      PickemWeek.select("week").where("season = ? AND pickem_pool_id = ?",
                                      @pool.current_season,
                                      params[:id]).all
    end
    
    def get_previous_week
      @pool = PickemPool.find(params[:id])
      @season = @pool.pickem_rules.where("config_key = ?", "current_season").first
      @week = @pool.pickem_rules.where("config_key = ?", "current_week").first
      @current_week = PickemWeek.where("pickem_pool_id = ? AND season = ? AND week = ?", 
                                        params[:id],
                                        @season.config_value,
                                        @week.config_value.to_i - 1).first

    end

    def get_weekly_games(poolId)
      season = @pool.pickem_rules.where("config_key = ?", "current_season").first
      week = @pool.pickem_rules.where("config_key = ?", "current_week").first
      includePro = @pool.pickem_rules.where("config_key = ?", "college").first
      includeCollege = @pool.pickem_rules.where("config_key = ?", "pro").first
      @games = Game.find_by_season_week(season.config_value, week.config_value,
                                      includePro.config_value, includeCollege.config_value)

    end
end
