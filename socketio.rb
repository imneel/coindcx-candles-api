# frozen_string_literal: true

require_relative "config/environment"

require "socket.io-client-simple"

def markets
  url = ENV.fetch("MARKET_URL")
  text_resp = Net::HTTP.get(URI.parse(url))
  JSON.parse(text_resp).pluck("pair")
end

socket = SocketIO::Client::Simple.connect(ENV.fetch("SOCKETIO_URL"), transport: "websocket")
socket.auto_reconnection = true

socket.on :connect do
  Rails.logger.info("SocketIO connect!!!")
  markets.each {|market| socket.emit("join", {channelName: market}) }
end

socket.on :disconnect do
  Rails.logger.info("SocketIO disconnected!!")
end

socket.on :"new-trade" do |msg|
  data = JSON.parse(msg["data"])
  ::TradeRecordJob.perform_later(data)
end

socket.on :error do |err|
  Rails.logger.error("SocketIO error: #{err}")
end

loop do
  sleep 0.2
end
