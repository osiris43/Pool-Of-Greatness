class SurvivorPoolsController < ApplicationController
  def index
  end
  
  def show
    @pool = SurvivorPool.find(params[:id])
    @title = "#{@pool.name} Home"
  end

  def viewpicksheet
    @title = "Picksheet"
    @pool = SurvivorPool.find(params[:id])
    @games = @pool.get_weekly_games
  end
end
