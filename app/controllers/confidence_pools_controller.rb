class ConfidencePoolsController < ApplicationController
  def show
    @pool = ConfidencePool.find(params[:id])
    @title = @pool.name
  end

  def administer
    @pool = ConfidencePool.find(params[:id])
    @title = "Administer #{@pool.name}"
  end

  def viewbowls
    @pool = ConfidencePool.find(params[:id])

    @bowls = Bowl.where("season = ?", "2010-2011").all
  end

  def save_picks
    @pool = ConfidencePool.find(params[:id])

    redirect_to(confidence_pool_path(@pool))
  end
end
