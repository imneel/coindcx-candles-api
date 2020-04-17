# frozen_string_literal: true

class TradeRecordJob < ApplicationJob
  def perform(payload)
    serv = ::TradeRecordService.new(payload)
    return true if serv.record

    Rails.logger.error("TradeRecordJob failed! Error(s): #{serv.errors.messages} Payload: #{payload}")
  end
end
