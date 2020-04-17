# frozen_string_literal: true

url = ENV.fetch("MARKET_URL")
resp = Net::HTTP.get(URI.parse(url))
JSON.parse(resp).each do |market|
  Market.find_or_create_by!(pair: market["pair"], symbol: market["symbol"])
end
