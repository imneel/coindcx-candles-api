# frozen_string_literal: true

class TradeRecordService < ApplicationService
  validates :market_pair, :market_symbol, presence: true

  def record
    return false unless valid?

    find_or_create_market &&
      insert_trade &&
      set_result
  end

  private

  attr_reader :market, :trade

  def market_pair
    params["channel"]
  end

  def market_symbol
    params["s"]
  end

  def market_cache_key
    "market-#{market_pair}-#{market_symbol}"
  end

  def find_or_create_market
    @market = Rails.cache.fetch(market_cache_key, skip_nil: true, expires_in: 24.hours) {
      Market.find_or_create_by!(pair: market_pair, symbol: market_symbol)
    }
  end

  def trade_attributes
    {
      market:       market,
      price:        params["p"],
      quantity:     params["q"],
      traded_at:    params["T"],
      market_maker: params["m"]
    }
  end

  def insert_trade
    @trade ||= Trade.new
    trade.assign_attributes(trade_attributes)
    trade.save || merge_errors_from(trade, "insert_trade")
  end

  def set_result
    @result = trade
  end
end
