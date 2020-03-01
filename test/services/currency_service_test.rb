require 'test_helper'

class CurrencyServiceTest < Minitest::Test
  describe 'successfully fetches latest currenices' do
    before do
      @btc_body = { volume_24h: "43.61000000", volume: "9.13100000", status: "continuous",
      session: 21780, prev_close: "13180.00000000", last: "13140.00000000", current_time: "2020-03-01T16:32:58.573418Z",
      bid: "13120.00000000", ask: "13160.00000000" , transition_time: "2020-03-01T16:50:00Z"}

      @eth_body = { volume_24h: "204.700000000", volume: "35.300000000", transition_time: "2020-03-01T16:50:00Z",
      status: "continuous", session: 21780, prev_close: "338.50000000", last: "334.40000000", 
      current_time: "2020-03-01T16:45:21.489277Z", bid: "329.80000000", ask: "332.70000000"}

      stub_request(:get, "https://data.exchange.coinjar.com/products/ETHAUD/ticker").to_return(body: @eth_body.to_json)
      stub_request(:get, "https://data.exchange.coinjar.com/products/BTCAUD/ticker").to_return(body: @btc_body.to_json)

      @response_keys = [:current_time, :bid, :ask, :last]
    end

    it 'fetches BTC latest currency' do
      @btc_response = CurrencyService.fetch_btc

      @response_keys.each do |key|
        assert_equal @btc_body[key], @btc_response[key]
      end
    end

    it 'fetches ETH latest currency' do
      @eth_response = CurrencyService.fetch_eth

      @response_keys.each do |key|
        assert_equal @eth_body[key], @eth_response[key]
      end
    end
  end

  describe 'return empty hash while fetching currency' do
    before do
      stub_request(:get, "https://data.exchange.coinjar.com/products/ETHAUD/ticker").to_return(body: "", status: 400)
    end

    it 'returns {} when code is not 200' do
      @response = CurrencyService.fetch_eth
      assert_equal @response, {}
    end

    it 'returns {} when body is empty' do
      @response = CurrencyService.fetch_eth
      assert_equal @response, {}
    end
  end
end
