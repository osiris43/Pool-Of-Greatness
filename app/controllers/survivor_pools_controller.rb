class SurvivorPoolsController < ApplicationController
  before_filter :login_required 

  def index

  end
  
  def show
    @pool = SurvivorPool.find(params[:id])
    @title = "#{@pool.name} Home"
    @current_week = @pool.current_week
    @current_pick = current_user.survivor_entries.where(:week => @current_week, :season => "2011-2012").first
    @teamscount = @pool.survivor_entries.where(:week => @current_week).all.group_by{|entry| entry.team.teamname}
  end

  def viewpicksheet
    @title = "Picksheet"
    @pool = SurvivorPool.find(params[:id])
    @games = @pool.get_weekly_games
    @entry = SurvivorEntry.where(:user_id => current_user.id, :week => @games[0].week, :season => @games[0].season).first
    if @entry.nil?
      @entry = SurvivorEntry.new
    end
    @picked_teams = current_user.survivor_entries.where("week < ?", @games[0].week).all.map{|entry| entry.team.id}
    @pastgames = @games.where("gamedate < ?", DateTime.now).all.map{|game| game.id}
    if @pastgames.include?(@entry.game_id)
      flash[:notice] = "You picked a game this week that has already started.  You cannot change picks."
    end
  end

  def makepick
    @pool = SurvivorPool.find(params[:id])
    team = Team.find(params[:teamid]) 
    @games = @pool.get_weekly_games
    game = @games.where("away_team_id = ? OR home_team_id = ?", team.id, team.id).first

    @entry = SurvivorEntry.where(:user_id => current_user.id, :week => game.week, :season => game.season).first
    if @entry.nil?
      current_user.survivor_entries.create!(:game => game, :team => team, :week => game.week, :season => game.season, :pool_id => @pool.id)
      if @games[0].week == 1
        add_initial_transaction(@pool.name)
      end
    else
      @entry.update_attributes(:game => game, :team => team)
      @entry.save
    end
    flash[:notice] = "Week #{game.week} pick successfully made"

    redirect_to survivor_pool_path(@pool) 
  end

  def standings
    @pool = SurvivorPool.find(params[:id])
    @title = "Pool Standings"
    @current_week = @pool.current_week 

    @users = User.where("survivor_entries_count > 0").all

    if @users.count == 0
      flash[:notice] = fading_flash_message( "No standings until after the week 1 deadline",5)
    end
  end

  private 
    def add_initial_transaction(name)
      current_user.account.transactions.create!(:pooltype => "SurvivorPool", 
                                                :poolname => name, 
                                                :amount => -50,
                                                :description => 'Survivor Pool fee')
    end
end
