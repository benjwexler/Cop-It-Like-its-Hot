class HoldingsController < ApplicationController
  before_action :set_holding, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include ActionView::Helpers::NumberHelper

  # GET /holdings
  # GET /holdings.json
  def index
    @user = current_user 
    

    # displays how much cash the user has for purchases 
    p @user_account_balance = number_to_currency(@user.account_balance)

    p @holdings = @user.holdings


    @holdingsObj = {}
    i = 1

    @portfolio_gross = 0 

    
    # the .each goes through the users holdings and creates and object with all relevant info to be displayed on screen
    
    @holdings.each do |holding|
        @holdingsObj[i] = {
              "stock_name" => holding.stock_symbol,
              "openingPrice" => IEX::Resources::OHLC.get(holding.stock_symbol).open.price,
              "currentPrice" => IEX::Resources::Price.get(holding.stock_symbol),
              "shares" => holding.shares
              }

              @portfolio_gross += (@holdingsObj[i]["currentPrice"] * holding.shares)
        i+=1 
    end 
    # @hidden_portfolio_gross = @portfolio_gros
    # p @portfolio_gross = number_to_currency(@portfolio_gross)
    p @portfolio_gross
    i =1 
    @length = @holdingsObj.length
#this while loop will be put into the html.erb file to create the needed rows for portfolio
    # while i <= @length
    #   p @holdingsObj[i]["stock_name"]
    #   p @holdingsObj[i]["openingPrice"]
    #   p @holdingsObj[i]["currentPrice"]
    #   p @holdingsObj[i]["shares"]
    #   i+=1
    # end 

  end

  # GET /holdings/1
  # GET /holdings/1.json
  def show
  end

  # GET /holdings/new
  def new
    @holding = Holding.new
  end

  # GET /holdings/1/edit
  def edit
  end

  # POST /holdings
  # POST /holdings.json
  def create
    # p " ndein edij efije"
    # p holding_params["user_id"]
    # p params[:user_id]
    # p params[:stock_symbol]
    p params["holding"]["stock_symbol"]
    @user = current_user 
    @holdings = @user.holdings
    p shares_to_be_added = params["holding"]["shares"].to_i
    p current_user_id = @user.id

    # p @holdings.where(stock_symbol: ["fb"]).length 
  
    p user_owned_stock = params["holding"]["stock_symbol"]
    p " ndein edij efije"
    if @holdings.where(stock_symbol: [user_owned_stock]).length == 0
      # @holding = Holding.new(holding_params)
      @holding = Holding.new(:user_id => current_user_id, :stock_symbol => user_owned_stock, :shares => shares_to_be_added)
      # @holding = Holding.new(holding_params)
      respond_to do |format|
        if @holding.save
          format.html { redirect_to @holding, notice: 'Holding was successfully created.' }
          format.json { render :show, status: :created, location: @holding }
        else
          format.html { render :new }
          format.json { render json: @holding.errors, status: :unprocessable_entity }
        end
      end
    else
      p  holding_to_be_updated = @holdings.where(stock_symbol: [user_owned_stock])[0]
      p  previous_shares_owned = holding_to_be_updated.shares
      
      current_shares = previous_shares_owned + shares_to_be_added
        # p Holding.find(holding_id_to_be_updated)
        holding_to_be_updated.update_attribute(:shares, current_shares)
    end 
      

    
  end

  # PATCH/PUT /holdings/1
  # PATCH/PUT /holdings/1.json
  def update
    respond_to do |format|
      if @holding.update(holding_params)
        format.html { redirect_to @holding, notice: 'Holding was successfully updated.' }
        format.json { render :show, status: :ok, location: @holding }
      else
        format.html { render :edit }
        format.json { render json: @holding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holdings/1
  # DELETE /holdings/1.json
  def destroy
    @holding.destroy
    respond_to do |format|
      format.html { redirect_to holdings_url, notice: 'Holding was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holding
      @holding = Holding.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holding_params
      params.require(:holding).permit(:user_id, :stock_symbol, :shares)
    end
end
