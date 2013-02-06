class OscarNomineesController < ApplicationController
  def index
    @nominees = OscarNominees.all
  end

  def new
    @nominee = OscarNominee.new
  end

  def create
    @nominee = OscarNominee.new(params[:oscar_nominee])
    if(@nominee.save)
      flash[:notice] = "Successfully created"
    else
      flash[:notice] = "Save failed"
    end

    redirect_to new_oscar_nominee_path
  end

end
