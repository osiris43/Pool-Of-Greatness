class SitesController < ApplicationController
  before_filter :login_required 
 
  def new
    @title = "Create a new pool"
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])
    @site.admin_id = current_user.id
    @site.users << current_user
    if @site.save
      redirect_to user_path(current_user), :notice => "You have successfully created the site."
    else
      render :action => 'new'
    end

  end

  def find 
    @title = "Search for sites"

  end

  def search
    @sites = []
    if params[:site_search] == nil || params[:site_search] == ''
      flash[:notice] = "You must enter a name to search by."
      render :action => 'new'
    else 
      @sites = Site.where("name LIKE '" + params[:site_search] + "%'").all
      if @sites == nil || @sites.count < 1
        flash[:notice] = "No sites found"
      end
    end
  end

  def join
    @site = Site.find(params[:id])
    current_user.sites << @site
    current_user.save!
    redirect_to user_path(current_user)
  end

  def newpool
    @site = Site.find(params[:id])
  end

  def add_pool
    @site = Site.find(params[:id])
    case params[:pool][:type]
    when "PickemPool"
      @pool = PickemPool.new(:name => params[:poolname], :admin_id => current_user.id)
      @site.pools << @pool
      @site.save
    end
    redirect_to user_path(current_user)
  end

end
