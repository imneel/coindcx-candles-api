# frozen_string_literal: true

require "test_helper"

class TradeRecordTest < ActiveSupport::TestCase
  test "empty" do
    assert_no_difference "Market.count" do
      assert_no_difference "Trade.count" do
        service = TradeRecordService.new({})
        assert_not service.record
        assert_equal({market_pair: ["can't be blank"], market_symbol: ["can't be blank"]}, service.errors.messages)
      end
    end
  end

  test "invalid" do
    params = {
      "channel" => "test-01",
      "s"       => "test-01",
      "p"       => 0,
      "q"       => 0,
      "T"       => 0,
      "m"       => nil
    }
    expected_errors = {
      "insert_trade.price":        ["must be greater than 0"],
      "insert_trade.quantity":     ["must be greater than 0"],
      "insert_trade.traded_at":    ["can't be prior to 2018"],
      "insert_trade.market_maker": ["should be true or false"]
    }
    assert_difference "Market.count", 1 do
      assert_no_difference "Trade.count" do
        service = TradeRecordService.new(params)
        assert_not service.record
        assert_equal(expected_errors, service.errors.messages)
      end
    end
  end

  test "valid" do
    params = {
      "channel" => "test-01",
      "s"       => "test-01",
      "p"       => 1.0,
      "q"       => 1.0,
      "T"       => 1_514_788_200,
      "m"       => true
    }
    assert_difference "Market.count", 1 do
      assert_difference "Trade.count", 1 do
        service = TradeRecordService.new(params)
        assert service.record
      end
    end
  end
end
