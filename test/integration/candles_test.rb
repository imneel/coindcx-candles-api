# frozen_string_literal: true

require "test_helper"

class CandlesTest < ActionDispatch::IntegrationTest
  setup do
    @error_response = {"code" => 400, "message" => "Invalid request.", "status" => "error"}
  end

  test "blank query" do
    get candles_url
    assert_response :bad_request
    assert_equal(@error_response, JSON.parse(response.body))
  end

  test "invalid query" do
    get candles_url, params: {interval: "-1m", pair: "wrong-pair"}
    assert_response :bad_request
    assert_equal(@error_response, JSON.parse(response.body))
  end

  test "valid query for pair one" do
    get candles_url, params: {interval: "1m", pair: "one"}
    assert_response :success
    assert_equal([{"time" => 1_587_184_860_000, "open" => "0.99", "high" => "0.99", "low" => "0.99", "close" => "0.99", "volume" => "1.99"}], JSON.parse(response.body))
  end

  test "valid query for pair two" do
    get candles_url, params: {interval: "1m", pair: "two"}
    assert_response :success
    assert_equal([{"time" => 1_587_184_860_000, "open" => "2.99", "high" => "2.99", "low" => "2.99", "close" => "2.99", "volume" => "3.99"}], JSON.parse(response.body))
  end

  test "blank result" do
    get candles_url, params: {interval: "1m", pair: "two", startTime: 1_587_184_860_010, endTime: 1_587_184_860_010}
    assert_response :success
    assert_equal([], JSON.parse(response.body))
  end
end
