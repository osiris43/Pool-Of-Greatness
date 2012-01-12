class NbaTeamsController < ApplicationController
  def new
    @team = NbaTeam.new
  end

  def create
    @team = NbaTeam.new(params[:nba_team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to new_nba_team_path, 
                      :notice => "Team saved"}
      else
        format.html { render "new", 
                      :notice => "Team not saved"}
      end
    end
  end

end
