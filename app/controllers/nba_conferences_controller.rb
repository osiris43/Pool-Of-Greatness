class NbaConferencesController < ApplicationController
  def new
    @conference = NbaConference.new
  end

  def create
    @conference = NbaConference.new(params[:nba_conference])

    respond_to do |format|
      if @conference.save
        format.html { redirect_to new_nba_conference_path, 
                      :notice => 'Conference created'}
      else
        format.html { render :action => "new", 
                      :notice => "Conference save failed"}
      end
    end
  end

end
