class TeamsController < ApplicationController
  def index 
    if params[:q]
      @teams = Team.all(:conditions => ["teamname like ?", params[:q] + '%'])
    else
      @teams = Team.all
    end

    respond_to do |wants|
      wants.html
      wants.js
    end
  end

  def show
    @team = Team.find(params[:id])
    @title = @team.display_name
  end
end
