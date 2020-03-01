require 'test_helper'

class CurrenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @body = { volume_24h: "43.61000000", volume: "9.13100000", status: "continuous",
      session: 21780, prev_close: "13180.00000000", last: "13140.00000000", current_time: "2020-03-01T16:32:58.573418Z",
      bid: "13120.00000000", ask: "13160.00000000" , transition_time: "2020-03-01T16:50:00Z"}
    stub_request(:get, "https://data.exchange.coinjar.com/products/ETHAUD/ticker").to_return(body: @body.to_json)
    stub_request(:get, "https://data.exchange.coinjar.com/products/BTCAUD/ticker").to_return(body: @body.to_json)
  end

  test 'index' do
    get listing_path
    assert_response :success
    assert_select 'h1', "Crypto Currencies"
  end

  test 'index via AJAX' do
    get listing_path, xhr: true
    assert_response :success
  end

  test 'history with valid currenices' do
    get '/history/eth'
    assert_response :success
  end

  test 'history with invalid currenices' do
    assert_raise(ActionController::RoutingError) { get '/history/abc' }
  end

  test 'capture latest currencies' do
    history_count = History.count

    post capture_path, xhr: true
    assert_response :success
    assert_equal History.count, history_count + 2
  end
end
