class TransactionsController < ApplicationController
  def index
    @title = "All Transactions"
    @site = Site.find(params[:site_id])
    @transactions = @site.transactions.paginate(:page => params[:page], :per_page => 15)
  end

  def new
    @title = "Add a transaction"
    @site = Site.find(params[:site_id])
  end

  def create
    @site = Site.find(params[:site_id])
    @pool = Pool.find(params[:pool][:id])
    @user = User.find(params[:user][:id])
    @transaction = @pool.transactions.build(:pooltype => @pool.type,
                                            :poolname => @pool.name,
                                            :amount => params[:amount],
                                            :description => params[:description],
                                            :account_id => @user.account.id)
   if @transaction.save
     flash[:success] = "Transaction created"
     redirect_to site_transactions_path(@site)
   else
     render 'new'
   end 
  end 

end
