class PoolTemplatesController < ApplicationController
  before_filter :login_required
  before_filter :admin_user_required

  def index
    @templates = PoolTemplate.all
  end

  def show
  end

  def new
    @template = PoolTemplate.new
  end

  def create
    @template = PoolTemplate.new(params[:pool_template])
    
    respond_to do |format|
      if @template.save
        format.html { redirect_to pool_templates_path, 
                      :notice => 'Template created'}
      else
        format.html { render :action => "new", 
                      :notice => "Template save failed"}
      end
    end
  end
end
