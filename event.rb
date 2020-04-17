# frozen_string_literal: true

require_relative "config/environment"

DEFUALT_SOCKET_URL = "wss://stream.coindcx.com/socket.io/?transport=websocket"
DEFUALT_MARKET_URL = "https://api.coindcx.com/exchange/v1/markets_details"

def markets
  url = ENV.fetch("MARKET_URL", DEFUALT_MARKET_URL)
  text_resp = Net::HTTP.get(URI.parse(url))
  JSON.parse(text_resp).pluck("pair")
end

def handle_message(message)
  _num, str = message.scan(/(\A\d+)(.*)/).first
  return true unless str.present?

  name, hash = JSON.parse(str)
  case name
  when "new-trade"
    data = JSON.parse(hash["data"])
    ::TradeRecordJob.perform_later(data)
  end
end

def em_run
  EM.run {
    url = ENV.fetch("SOCKET_URL", DEFUALT_SOCKET_URL)
    ws = Faye::WebSocket::Client.new(url)

    ws.on :open do |_|
      Rails.logger.info("WS open!")
      markets.each {|pair| ws.send("42#{['join', {channelName: pair}].to_json}") }
    end

    ws.on :message do |event|
      handle_message(event.data)
    end

    ws.on :close do |event|
      Rails.logger.info("WS closed! #{event.code} #{event.reason}")
      em_run
    end
  }
end

em_run
