module Bitstamp
  class Transaction
    include Virtus.model

    attribute :id, Integer
    attribute :order_id, Integer
    attribute :fee, Decimal
    attribute :datetime, Time

    attribute :volume, Decimal
    attribute :amount, Decimal
    attribute :rate, Decimal
  end
end
