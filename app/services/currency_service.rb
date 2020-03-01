class CurrencyService
  include HTTParty
  base_uri 'https://data.exchange.coinjar.com/products/'
  DETAIL_KEYS = [:current_time, :bid, :ask, :last]

  class << self
    def fetch_btc
      fetch_currency('BTCAUD')
    end

    def fetch_eth
      fetch_currency('ETHAUD')
    end

    private

    def fetch_currency(currency_name = nil)
      response = self.get("/#{currency_name}/ticker")
      return {} unless response.code.eql?(200)

      currency_details = JSON.parse(response.body).with_indifferent_access
      currency_details.present? ? (currency_details.slice *DETAIL_KEYS) : {}
    rescue => e
      puts "Exception occured while fetching currency: #{e}"
      {}
    end
  end
end