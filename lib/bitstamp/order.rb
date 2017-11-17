module Bitstamp
  class Order
    include Virtus.model

    attribute :id, Integer
    attribute :price, Decimal
    attribute :amount, Decimal
    attribute :datetime, Time
  end
end
