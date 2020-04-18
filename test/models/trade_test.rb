# frozen_string_literal: true

require "test_helper"

class TradeTest < ActiveSupport::TestCase
  test "blank" do
    trade = Trade.new
    assert_not trade.valid?
    expected_errors = {
      market:    ["must exist"],
      price:     ["can't be blank", "is not a number"],
      quantity:  ["can't be blank", "is not a number"],
      traded_at: ["can't be blank", "can't be prior to 2018"]
    }
    assert_equal(expected_errors, trade.errors.messages)
  end

  test "invalid" do
    trade = Trade.new(market: markets(:one), traded_at: 0, price: 0, quantity: 0, market_maker: nil)
    assert_not trade.valid?
    expected_errors = {
      price:        ["must be greater than 0"],
      quantity:     ["must be greater than 0"],
      traded_at:    ["can't be prior to 2018"],
      market_maker: ["should be true or false"]
    }
    assert_equal(expected_errors, trade.errors.messages)
  end

  test "valid" do
    trade = Trade.new(market: markets(:one), traded_at: 1_514_788_200, price: 1.0, quantity: 1.0, market_maker: false)
    assert trade.save
  end
end
