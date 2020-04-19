# frozen_string_literal: true

Rails.application.routes.draw do
  get "/market_data/candles", to: "candles#search", as: "candles"
  get "/", to: proc { [200, {"Content-Type" => "application/json"}, [{code: "OK"}.to_json]] }
end
