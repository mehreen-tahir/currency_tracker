require 'test_helper'

class HistoryTest < ActiveSupport::TestCase

  describe 'factory' do
    it 'has a valid factory' do
      assert FactoryBot.build(:history).valid?
    end
  end

  describe 'validations' do
    it 'validate presences' do
      history = History.new

      assert_equal false, history.valid?
      assert_equal [:currency, :time], history.errors.messages.keys
      assert_equal "can't be blank", history.errors.messages[:currency].first
    end
  end


  describe 'order scope' do
    before do
      History.destroy_all
      @history  = FactoryBot.create(:history, time: Time.now)
      @history1 = FactoryBot.create(:history, time: Time.now + 1.day)
      @history2 = FactoryBot.create(:history, time: Time.now - 1.day)
    end

    it 'validates time ordering' do
      histories = History.all.ordered_by_time

      assert_equal [@history1.id, @history.id, @history2.id], histories.pluck(:id)
      assert_equal 3, histories.count
    end
  end

  describe 'save latest prices' do
    before do
      body = { volume_24h: "43.61000000", volume: "9.13100000", status: "continuous",
        session: 21780, prev_close: "13180.00000000", last: "13140.00000000", current_time: "2020-03-01T16:32:58.573418Z",
        bid: "13120.00000000", ask: "13160.00000000" , transition_time: "2020-03-01T16:50:00Z"}

      stub_request(:get, "https://data.exchange.coinjar.com/products/ETHAUD/ticker").to_return(body: body.to_json)
      stub_request(:get, "https://data.exchange.coinjar.com/products/BTCAUD/ticker").to_return(body: body.to_json)

      @history_count    = History.count
      @service_response = body.slice(*[:current_time, :bid, :ask, :last])
    end

    it 'saves latest currencies and changes count' do
      CurrencyService.stub "fetch_btc", @service_response do
        response = History.save_latest_prices

        assert_equal true, response
      end
      assert_equal History.count, @history_count + 2
    end

    it 'throws error and return false' do
      CurrencyService.stub "fetch_btc", {} do
        response = History.save_latest_prices

        assert_equal false, response
      end
      assert_equal History.count, @history_count
    end
  end
end
