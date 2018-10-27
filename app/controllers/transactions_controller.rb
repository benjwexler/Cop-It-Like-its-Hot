class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /transactions
  # GET /transactions.json
  def index
    @user = current_user 
    @transactions = @user.transactions
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @user = current_user 
    current_user_id = @user.id
    shares_to_be_added = params["transaction"]["shares"].to_i
    user_owned_stock = params["transaction"]["stock_symbol"]
    p type_of_transaction = params["transaction"]["buy_or_sell"]
    p price_per_share = params["transaction"]["price_per_share"].to_f
    p "bnefijnfekle l"
    @transaction = Transaction.new(:user_id => current_user_id, :buy_or_sell => type_of_transaction, :stock_symbol => user_owned_stock, :shares => shares_to_be_added, :price_per_share => price_per_share)
    # @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
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
