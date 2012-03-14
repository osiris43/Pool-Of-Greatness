class NbaStatImportErrorsController < ApplicationController
  before_filter :login_required
  before_filter :admin_user_required

  def show
    @title = "Import Errors"
    @errors = NbaStatImportError.all
  end

  def destroy_all
    record_count = NbaStatImportError.delete_all
    flash[:notice] = "#{record_count} records deleted"
    redirect_to(nba_stat_import_errors_show_url)
  end
end
