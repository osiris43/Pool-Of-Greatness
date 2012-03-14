class NbaStatImportErrorsController < ApplicationController
  before_filter :login_required
  before_filter :admin_user_required

  def show
    @title = "Import Errors"
    @errors = NbaStatImportError.all
  end

  def destroy_all
    NbaStatImportError.delete_all
    flash[:notice] = "All records deleted"
    redirect_to 'show'
  end
end
