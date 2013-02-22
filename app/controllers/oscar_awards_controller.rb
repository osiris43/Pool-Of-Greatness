class OscarAwardsController < ApplicationController
  def index
    @awards = OscarAward.all
  end

  def show
    @award = OscarAward.find(params[:id])
  end

  def new
    @award = OscarAward.new
  end

  def create
    @award = OscarAward.new(params[:oscar_award])
    if(@award.save)
      flash[:notice] = "Successfully created"
    else
      flash[:notice] = "Save failed"
    end

    redirect_to new_oscar_award_path
  end

  def edit
  end

  def update
  end

  def add_nominations

  end

end
