class SurvivorPoolsController < ApplicationController
  before_filter :login_required 

  def index

  end
  
  def show
    @pool = SurvivorPool.find(params[:id])
    @title = "#{@pool.name} Home"
    @current_week = @pool.current_week
    @current_pick = current_user.survivor_entries.where(:week => @current_week, :season => "2011-2012").first
    @teamscount = @pool.current_session.survivor_entries.where(:week => @current_week).all.group_by{|entry| entry.team.teamname}
  end

  def viewpicksheet
    @title = "Picksheet"
    @pool = SurvivorPool.find(params[:id])
    @games = @pool.get_weekly_games
    @entry = SurvivorEntry.where(:user_id => current_user.id, :week => @games[0].week, :season => @games[0].season).first
    if @entry.nil?
      @entry = SurvivorEntry.new
    end
    #@picked_teams = current_user.survivor_entries.where("week < ?", @games[0].week).all.map{|entry| entry.team.id}
    @picked_teams = @pool.current_session.survivor_entries.where("user_id = ? AND week < ?", current_user.id, 
                                                                 @games[0].week).all.map{|entry| entry.team.id}

    @pastgames = @games.where("gamedate < ?", DateTime.current.advance(:hours => -4)).all.map{|game| game.id}
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
      current_user.survivor_entries.create!(:game => game, 
                                            :team => team, 
                                            :week => game.week, 
                                            :season => game.season, 
                                            :survivor_session => @pool.current_session)

      if current_user.debit_for_survivor?(@pool.current_session.description)
        add_initial_transaction(@pool)
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

    @users = @pool.current_session.users.group_by(&:id).values.map{|user_array| user_array[0]}

    if @users.count == 0
      flash[:notice] = fading_flash_message( "No one has made a pick yet",5)
    end
  end

  def history
    @title = "Pool History"
    @pool = SurvivorPool.find(params[:id])
    logger.debug "Sessions Count: #{@pool.survivor_sessions.count}"
  end

  def administer
    @title = "Pool Administration"
    @pool = SurvivorPool.find(params[:id])
  end

  private 
    def add_initial_transaction(pool)
      current_user.account.transactions.create!(:pooltype => "SurvivorPool", 
                                                :poolname => pool.name, 
                                                :amount => -50,
                                                :description => "#{pool.current_session.description} fee",
                                                :pool_id => pool.id)
    end
end
