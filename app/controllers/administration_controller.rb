class AdministrationController < ApplicationController
  before_filter :login_required
  before_filter :admin_user_required

  def index
  end

  def upload_qualifiers
    @tourney = MastersTournament.find_by_year(params[:year])
    if(@tourney.nil?)
      @tourney = MastersTournament.create!(:year => params[:year])
    end
    @tourney.importfile = params[:importfile]
    @tourney.process
    flash[:success] = "Uploaded"
    redirect_to :appadmin
  end

  def create_masters_tournament
    year = params[:tournament][:year]
    if year == "" 
      flash[:notice] = "You must provide a year"
      return render 'index'
    end

    MastersTournament.create!(:year => year)
    flash[:success] = "Masters for year #{year} created"
    redirect_to :appadmin
  end
end
