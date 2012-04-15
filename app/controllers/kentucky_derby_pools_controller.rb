class KentuckyDerbyPoolsController < ApplicationController
  before_filter :login_required

  def show
    @pool = KentuckyDerbyPool.find(params[:id])
    @title = @pool.name
  end

  def show_window
    @pool = KentuckyDerbyPool.find(params[:id])
    @title = @pool.name
  end
end
