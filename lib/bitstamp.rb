require 'logger'
require 'virtus'

require 'bitstamp/config'
require 'bitstamp/client'
require 'bitstamp/order_book'
require 'bitstamp/order'
require 'bitstamp/transaction'

module Bitstamp
  extend self

  Error = Class.new(StandardError)

  attr_accessor :config

  def configure
    self.config ||= Bitstamp::Config.new
    yield(config)
  end

  def pair(base_currency, quote_currency)
    "#{base_currency}#{quote_currency}".downcase
  end

  def order_book(pair:)
    response = client.call(
      method: :get,
      path: "v2/order_book/#{pair}"
    )
    OrderBook.new(response)
  end

  def balance
    client.call(
      method: :post,
      path: 'v2/balance/',
      auth: true
    )
  end

  def user_transactions(pair:)
    response = client.call(
      method: :post,
      path: "v2/user_transactions/#{pair}/",
      auth: true
    )

    response.map do |tx|
      base = pair[0..2]
      quote = pair[-3..-1]

      Transaction.new(tx.merge(
        volume: tx[base],
        amount: tx[quote],
        rate: tx["#{base}_#{quote}"]
      ))
    end
  end

  def trade(pair:, action:, amount:)
    response = client.call(
      method: :post,
      path: "v2/#{action}/market/#{pair}/",
      payload: { amount: amount },
      auth: true
    )
    Order.new(response)
  end

  private

  def client
    Client.new(config)
  end
end
