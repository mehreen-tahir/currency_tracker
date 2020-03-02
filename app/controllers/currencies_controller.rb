class CurrenciesController < ApplicationController
  def index
    @btc_currency = CurrencyService.fetch_btc
    @eth_currency = CurrencyService.fetch_eth
  end

  def history
    history = History.public_send("#{params[:currency]}_currency")
    @history_list = history.ordered_by_time
    @chart_data = history.group("DATE(time)").maximum('last')
  end

  def capture
    response = History.save_latest_prices
    if response.present?
      flash.now[:success] = "Currency prices are captured"
    else
      flash.now[:alert] = "Currency prices could not be captured"
    end
  end
end
