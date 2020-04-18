# frozen_string_literal: true

class Trade < ApplicationRecord
  belongs_to :market
  validates :price, :quantity, presence: true, numericality: {greater_than: 0}
  validates :traded_at, presence: true, numericality: {greater_than_or_equal_to: 1_514_788_200, message: "can't be prior to 2018"}
  validates :market_maker, inclusion: {in: [true, false], message: "should be true or false"}
end
