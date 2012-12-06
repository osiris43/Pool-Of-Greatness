class BowlsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required

  def index
    @title = "Bowls"
    @bowls = Bowl.where("season = ?", Configuration.get_value_by_key("CurrentBowlSeason")).all
    @teams = Team.all.sort_by {|t| t.teamname}

    respond_to do |format|
      format.html
      format.json {render :json => @bowls}
    end
  end

  def new
    @title = "Create a new bowl"
    @bowl = Bowl.new
  end

  def create
    @bowl = Bowl.new(params[:bowl])

    if @bowl.save
      redirect_to bowls_path, :notice => "Bowl created"
    else
      render :action => 'new'
    end

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
