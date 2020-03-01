class History < ApplicationRecord
  enum currency: [:btc, :eth], _suffix: true

  validates :currency, :bid, :ask, :last, :time, presence: true
end
