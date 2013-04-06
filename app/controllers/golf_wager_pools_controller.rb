class GolfWagerPoolsController < ApplicationController
  before_filter :login_required
  
  def index
  end

  def show
    @pool = GolfWagerPool.find(params[:id])
    @title = @pool.name
  end

  def administer
    @pool = GolfWagerPool.find(params[:id])
  end

  def show_team
    @pool = GolfWagerPool.find(params[:id])
    @team = current_user.find_masters_pool_entry_by_year()
    masters = MastersPool.find_by_golf_wager_pool_id(@pool.id)
    @tourney = MastersTournament.find(masters.masters_tournament_id)
  end
end
