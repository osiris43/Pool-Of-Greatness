class TeamsController < ApplicationController
  def show
    @team = Team.find(params[:id])
    @title = @team.display_name
  end
end
