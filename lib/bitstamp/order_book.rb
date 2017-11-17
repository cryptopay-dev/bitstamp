module Bitstamp
  class OrderBook
    include Virtus.model

    attribute :asks, [Array]
    attribute :bids, [Array]
  end
end
