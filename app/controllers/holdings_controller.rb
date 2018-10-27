class HoldingsController < ApplicationController
  before_action :set_holding, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include ActionView::Helpers::NumberHelper

  # GET /holdings
  # GET /holdings.json
  def index
    # @holdings = Holding.all
    @user = current_user 
    p @user_account_balance = number_to_currency(@user.account_balance)

    p @holdings = @user.holdings

    @holdingsObj = {}
    i = 1
    
    @holdings.each do |holding|
        
        p IEX::Resources::Price.get(holding.stock_symbol)
        
        @holdingsObj[i] = {
              "stock_name" => holding.stock_symbol,
              "openingPrice" => IEX::Resources::OHLC.get(holding.stock_symbol).open.price,
              "currentPrice" => IEX::Resources::Price.get(holding.stock_symbol),
              "shares" => holding.shares
              }
        
        # [IEX::Resources::Price.get(holding.stock_symbol), holding.shares ]
        # holding.shares
        i+=1 
    end 
    # @holdingsObj.each do |holding|
    #   p holding
    # end 
    i =1 
    @length = @holdingsObj.length

    while i <= @length
      p @holdingsObj[i]["stock_name"]
      p @holdingsObj[i]["openingPrice"]
      p @holdingsObj[i]["currentPrice"]
      p @holdingsObj[i]["shares"]
      i+=1
    end 


    # p IEX::Resources::Price.get('aapl')
    # applOhlc = IEX::Resources::OHLC.get('aapl')
    # p applOhlc.open.price
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
    @holding = Holding.new(holding_params)

    respond_to do |format|
      if @holding.save
        format.html { redirect_to @holding, notice: 'Holding was successfully created.' }
        format.json { render :show, status: :created, location: @holding }
      else
        format.html { render :new }
        format.json { render json: @holding.errors, status: :unprocessable_entity }
      end
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
