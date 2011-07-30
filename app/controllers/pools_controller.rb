class PoolsController < ApplicationController
  before_filter :login_required
  before_filter :admin_user, :only => [:create]
  def new
    @pool = Pool.new
  end

  def create
    logger.debug(params)
    @pool = current_user.pools.build(params[:pool])
    if @pool.save
      # Add this user to his or her own pool
      @pool.poolusers.create(:user_id => current_user.id)

      session[:pool_id] = @pool.id
      redirect_to pickem_configure_path 
    else
      render 'new'
    end
  end

  def join 
    @pool = Pool.find(params[:pool])
    @pool.poolusers.create(:user_id => current_user.id)

    redirect_to current_user
  end

  def find
    @title = "Search Pools"
  end

  def search
    @pools = []
    if params[:pool_search] == nil || params[:pool_search] == ''
      flash[:notice] = "You must enter a name to search by."
      return
    end
    
    @pools = Pool.where("name LIKE '" + params[:pool_search] + "%'").all
    if @pools == nil || @pools.count < 1
      flash[:notice] = "No pools found"
    end
  end
  
  private
    def admin_user
      redirect_to(current_user) unless current_user.admin?
    end
end
