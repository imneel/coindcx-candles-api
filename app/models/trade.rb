# frozen_string_literal: true

class Trade < ApplicationRecord
  belongs_to :market
  validates :price, :quantity, presence: true, numericality: {greater_than: 0}
  validates :traded_at, presence: true, numericality: {greater_than_equal_to: 1_514_788_200}
end
