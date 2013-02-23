class PgaPlayersController < ApplicationController
  def index
    @players = PgaPlayer.all
    @pga_player = PgaPlayer.new
  end

  def new
  end

  def create
  end

end
