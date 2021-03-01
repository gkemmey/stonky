class StockChecksController < ApplicationController
  before_action :require_user

  def new
  end

  def show
    @quote = Finnhub::Quote.find_by(stock_symbol: params[:stock_symbol])

    flash.now[:warning] = "That doesn't look like a legit stock symbol 🤔" unless @quote

  rescue Finnhub::RequestError
    flash[:danger] = "Something broke 😬 Feel free to try again, tho."
    redirect_to new_stock_check_path
  end
end
