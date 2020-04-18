# frozen_string_literal: true

require "test_helper"

class MarketTest < ActiveSupport::TestCase
  test "invalid" do
    market = Market.new
    assert_not market.valid?
    assert_equal({pair: ["can't be blank"], symbol: ["can't be blank"]}, market.errors.messages)
  end

  test "valid" do
    market = Market.new(pair: "some-pair", symbol: "some-symbol")
    assert market.save
  end
end
