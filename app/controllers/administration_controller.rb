class AdministrationController < ApplicationController
  before_filter :login_required
  before_filter :admin_user_required

  def index
  end

end
