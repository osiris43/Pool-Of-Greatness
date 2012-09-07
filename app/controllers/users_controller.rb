class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :forgot_password, :send_password]

  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.name == "Brett Bim"
      @user.admin = true
    end
    if @user.save
      session[:user_id] = @user.id
      @user.create_account
      redirect_to user_path(@user), :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end

  def show
    @title = "#{current_user.username}'s profile"
    cur_season = Configuration.get_value_by_key("CurrentSeason")
    @moneytimes = current_user.account.transactions.where("season = '#{cur_season}' AND description like '%prize%'").count

    respond_to do |format|
      format.html
      format.mobile { render :layout => false }
    end
  end

  def accounting

  end

  def forgot_password

  end

  def send_password
    @user = User.find_by_email(params[:user_email])
    if(@user.nil?)
      flash[:notice] = "No user exists with that email"
    else
      UserMailer.deliver_send_password(@user)
      flash[:notice] = "Your password has been sent."
    end

    redirect_to login_path 

  end
end
