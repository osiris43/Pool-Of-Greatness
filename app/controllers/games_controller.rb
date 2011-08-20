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
    redirect_to user_path(current_user)
  end
  
  private
    def admin_required
      redirect_to user_path(current_user) unless current_user.admin?
    end
end
