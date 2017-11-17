require 'spec_helper'

describe Bitstamp do
  subject(:bitstamp) { described_class }

  describe '#pair' do
    it 'converts base/quote pair to bitstamp pair' do
      expect(Bitstamp.pair('BTC', 'EUR')).to eq 'btceur'
    end
  end

  describe '#order_book', vcr: { cassette_name: 'bitstamp/order_book' } do
    let(:pair) { 'btceur' }

    it 'returns order book' do
      order_book = bitstamp.order_book(pair: pair)

      expect(order_book.asks).to be_a Array
      expect(order_book.bids).to be_a Array
    end
  end

  describe '#balance', vcr: { cassette_name: 'bitstamp/balance' } do
    it 'returns balance' do
      balance = bitstamp.balance

      expect(balance['eur_available']).to be
    end
  end

  describe '#user_transactions', vcr: { cassette_name: 'bitstamp/user_transactions' } do
    let(:pair) { 'btceur' }

    it 'returns transactions' do
      transactions = bitstamp.user_transactions(pair: pair)

      expect(transactions).to be_a Array
    end
  end

  describe '#trade', vcr: { cassette_name: 'bitstamp/trade' } do
    let(:pair) { 'btceur' }

    it 'returns order' do
      order = bitstamp.trade(action: 'sell', amount: 0.001, pair: pair)

      expect(order.amount).to eq 0.001
    end
  end
end
