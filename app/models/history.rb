class History < ApplicationRecord
  enum currency: [:btc, :eth], _suffix: true

  validates :currency, :bid, :ask, :last, :time, presence: true
  validates :currency, inclusion: { in: currencies.keys }

  scope :ordered_by_time, -> { order(time: :desc) }

  def self.save_latest_prices
    self.currencies.keys.each do |currency|
      details = CurrencyService.public_send("fetch_#{currency}")
      history = History.new(currency: currency, bid: details[:bid], ask: details[:ask], last: details[:last], time: details[:current_time])
      history.save!
    end

    true
    rescue => e
      false
  end
end
