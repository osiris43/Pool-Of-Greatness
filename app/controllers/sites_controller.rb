class SitesController < ApplicationController
  before_filter :login_required 
  before_filter :site_owner, :except => [:new, :search, :join, :find, :create]

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
      @sites = Site.where("lower(name) LIKE '%" + params[:site_search].downcase + "%'").all
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
    @season = DbConfig.find_by_key("CurrentSeason").value 
    @week = 1
  end

  def add_pool
    @site = Site.find(params[:id])
    case params[:pool][:type]
    when "PickemPool"
      @pool = PickemPool.new(:name => params[:poolname], :admin_id => current_user.id)
      @site.pools << @pool
      @site.save

      @pool.pickem_weeks.create!(:season => params[:current_season],
                                 :week => params[:current_week],
                                 :deadline => params[:deadline])
      add_configuration(@pool)

    when "SurvivorPool"
      @pool = SurvivorPool.new(:name => params[:poolname], :admin_id => current_user.id)
      @site.pools << @pool
      @site.save
    when "ConfidencePool"
      @pool = ConfidencePool.new(:name => params[:poolname], :admin_id => current_user.id)
      @site.pools << @pool
      @site.save
    when "GolfWagerPool"
      @pool = GolfWagerPool.new(:name => params[:poolname], :admin_id => current_user.id)
      @site.pools << @pool
      @site.save
    when "KentuckyDerbyPool"
      @pool = KentuckyDerbyPool.new(:name => params[:poolname], :admin_id => current_user.id)
      @site.pools << @pool
      @site.save
    when "OscarPool"
      @pool = OscarPool.new(:name => params[:poolname], :admin_id => current_user.id)
      @site.pools << @pool
      @site.save
    end

    redirect_to user_path(current_user)
  end

  def administer
    @title = "Site Administration"
    @site = Site.find(params[:id])
  end

  def viewpools
    @title = "All Pools"
    @site = Site.find(params[:id])
  end

  def accounting_report
    @title = "Accounting Report"
    @site = Site.find(params[:id])
  end

  private 
    def site_owner
      @site = Site.find(params[:id])
      current_user.id == @site.admin_id
    end

    def add_configuration(pool)
      add_rule(@pool, :number_of_games, "number_of_games")
      add_rule(@pool, :college, "college")
      add_rule(@pool, :pro, "pro")
      add_rule(@pool, :current_season, "current_season")
      add_rule(@pool, :current_week, "current_week")
      add_rule(@pool, :weekly_fee, "weekly_fee")

      if params[:include_weekly_jackpot]
        pool.create_jackpot(:weeklyjackpot => 0,
                            :seasonjackpot => 0,
                            :weeklyamount => params[:weekly_jackpot_amount],
                            :seasonamount => params[:season_jackpot_amount])

        add_rule(@pool, :no_of_jackpot_wins, "no_of_jackpot_wins")
      end
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
