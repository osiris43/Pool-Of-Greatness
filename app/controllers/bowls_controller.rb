class BowlsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required

  def index
    @title = "Bowls"
    @bowls = Bowl.where("season = ?", "2010-2011").all
    @teams = Team.all.sort_by {|t| t.teamname}
  end

  def update_all
    @bowls = Bowl.update(params[:bowls].keys, params[:bowls].values).reject {|b| b.errors.empty?}
    flash[:notice] = "Bowls updated"
   
    redirect_to user_path(current_user)
  end

  private
    def admin_required
      redirect_to user_path(current_user) unless current_user.admin?
    end

end
