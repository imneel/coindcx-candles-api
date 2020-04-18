# frozen_string_literal: true

class CandlesSearchService < ApplicationService
  validates :pair, presence: true
  validates :market, presence: true, if: :pair
  validates :interval, inclusion: {in: %w[1m 5m 15m]}
  validates :limit, numericality: {only_integer: true, greater_than_equal_to: 1, less_than_or_equal_to: 1000}
  validates :start_time, numericality: {only_integer: true, greater_than_equal_to: 1}, allow_blank: true
  validates :end_time, numericality: {only_integer: true, greater_than_equal_to: 1}, allow_blank: true
  validate  :validate_time_bounds

  def search
    return false unless valid?

    set_result
  end

  private

  def validate_time_bounds
    return true unless start_time && end_time && start_time > end_time

    errors.add(:base, "invalid time value(s)")
    false
  end

  def market
    return unless pair.present?

    @market ||= Rails.cache.fetch("market-by-pair-#{pair}", skip_nil: true, expires_in: 1.day) {
      Market.find_by(pair: pair)
    }
  end

  def pair
    params["pair"]
  end

  def interval
    params["interval"]
  end

  def limit
    params["limit"]&.to_i || 500
  end

  def start_time
    params["startTime"]&.to_i
  end

  def end_time
    return unless params["endTime"]
    out = params["endTime"]&.to_i
    out - (out % divider) + divider
  end

  def interval_unit
    interval.scan(/\A(\d+)(.*)\z/)[0][1]
  end

  def interval_multiplier
    interval.scan(/\A(\d+)(.*)\z/)[0][0]
  end

  def divider
    @divider ||= interval_multiplier.to_i * 60_000
  end

  def query_resp
    output = Trade.where(market_id: market.id)
    output = output.where("traded_at >= ?", start_time) if start_time
    output = output.where("traded_at < ?", end_time) if end_time
    output.order(Arel.sql("traded_at - MOD(traded_at, #{divider}) DESC"))
          .group(Arel.sql("traded_at - MOD(traded_at, #{divider})"))
          .pluck(
            Arel.sql("((ARRAY_AGG(price ORDER BY traded_at ASC))[1])::FLOAT"),
            Arel.sql("MAX(price)::FLOAT"),
            Arel.sql("MIN(price)::FLOAT"),
            Arel.sql("SUM(quantity)::FLOAT"),
            Arel.sql("((ARRAY_AGG(price ORDER BY traded_at DESC))[1])::FLOAT"),
            Arel.sql("traded_at - MOD(traded_at, #{divider})")
          )
  end

  def set_result
    @result = query_resp.map {|row| %i[open high low volume close time].zip(row).to_h }
  end
end
