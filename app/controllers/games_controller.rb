class GamesController < ApplicationController
  before_filter :login_required
  before_filter :admin_required

  def index
    @title = "All Games"
  end

  def find
    @title = "Games Found"
    @games = Game.where("gamedate between ? AND ?", params[:begin_date], params[:end_date])
    logger.debug "Found #{@games.count} games"
  end

  def update_individual
    @games = Game.update(params[:games].keys, params[:games].values).reject { |g| g.errors.empty?}
    flash[:notice] = "Games updated"

    # TODO this needs to only happen for pickem pools. 
    if params[:scoregames]
      pools = PickemPool.all
      pools.each do |pool|
        week = PickemWeek.get_current_week(pool.id)
        week.score
        week.update_accounting
        @season = pool.pickem_rules.where("config_key = ?", "current_season").first
        @week = pool.pickem_rules.where("config_key = ?", "current_week").first
        pool.pickem_weeks.create!(:season => @season.config_value,
                                  :week => @week.config_value, 
                                  :deadline => week.deadline + 7)
      end
      
    end 

    
    redirect_to user_path(current_user)
  end
  
  private
    def admin_required
      redirect_to user_path(current_user) unless current_user.admin?
    end
end
