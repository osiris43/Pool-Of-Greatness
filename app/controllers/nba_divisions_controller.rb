class NbaDivisionsController < ApplicationController
  def new
    @division = NbaDivision.new
  end

  def create
    @division = NbaDivision.new(params[:nba_division])

    respond_to do |format| 
      if @division.save
        format.html { redirect_to new_nba_division_path,
                      :notice => "Division created"}
      else
        format.html { render :action => "new", 
                      :notice => "Division save failed"}

      end 
    end
  end

end
