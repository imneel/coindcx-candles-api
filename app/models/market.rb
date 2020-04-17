# frozen_string_literal: true

class Market < ApplicationRecord
  validates :pair, :symbol, presence: true
end
