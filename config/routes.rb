# frozen_string_literal: true

Rails.application.routes.draw do
  get "/market_data/candles", to: "candles#search", as: "candles"
end
