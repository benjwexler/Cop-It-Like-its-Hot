class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:update, :destroy]
  before_action :authenticate_user!
  # caches_page :index, :show  

  # I seem to have set up the routing where there has been an issue twice with verifying the authenticy token and the app crashes. The following line of code:

  # skip_before_action :verify_authenticity_token

  # is supposed to fix the app from crashing, but as I understand this can put my app at risk for Cross-Site Request Forgery (CSRF) attacks.
  
  


  # GET /transactions
  # GET /transactions.json
  def index
    @user = current_user 
    @transactions = @user.transactions.order(id: :desc)
    
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    redirect_to transactions_url
  end

  # GET /transactions/new
  def new
    # @transaction = Transaction.new
    redirect_to transactions_url
  end

  # GET /transactions/1/edit
  def edit
    redirect_to transactions_url
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @user = current_user 
    current_user_id = @user.id
    shares_to_be_added = params["transaction"]["shares"].to_i
    user_owned_stock = params["transaction"]["stock_symbol"].upcase
    type_of_transaction = params["transaction"]["buy_or_sell"]
    price_per_share = params["transaction"]["price_per_share"].to_f
   
    # I have hard coded the "buy_or_sell" type to be "BUY". If I add a sell feature this has to be changed
    @transaction = Transaction.create(:user_id => current_user_id, :buy_or_sell => "BUY", :stock_symbol => user_owned_stock, :shares => shares_to_be_added, :price_per_share => price_per_share)
    # @transaction = Transaction.new(transaction_params)
    user_account_balance_before_transaction =   @user.account_balance
  
    total_price_of_transaction = price_per_share * shares_to_be_added
   
     updated_user_account_balance = user_account_balance_before_transaction - total_price_of_transaction
    @user.update_attribute(:account_balance, updated_user_account_balance)

    @holdings = @user.holdings
  #CREATES HOLDING   
    if @holdings.where(stock_symbol: [user_owned_stock]).length == 0
      # @holding = Holding.new(holding_params)
      @holding = Holding.new(:user_id => current_user_id, :stock_symbol => user_owned_stock, :shares => shares_to_be_added)
      # @holding = Holding.new(holding_params)
      respond_to do |format|
        if @holding.save
          format.html {  }
          format.json { render :show, status: :created, location: @holding }
        else
          format.html { render :new }
          format.json { render json: @holding.errors, status: :unprocessable_entity }
        end
      end
    else
      holding_to_be_updated = @holdings.where(stock_symbol: [user_owned_stock])[0]
     previous_shares_owned = holding_to_be_updated.shares
      
      current_shares = previous_shares_owned + shares_to_be_added
        # p Holding.find(holding_id_to_be_updated)
        holding_to_be_updated.update_attribute(:shares, current_shares)
    end 

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to holdings_url, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:user_id, :buy_or_sell, :stock_symbol, :shares, :price_per_share)
    end
end
