# frozen_string_literal: true

class CandlesController < ApplicationController
  def search
    serv = CandlesSearchService.new(search_params)
    if serv.search
      render json: serv.result, status: :ok
    else
      render json: {code: 400, message: "Invalid request.", status: "error"}, status: :bad_request
    end
  end

  private

  def search_params
    params.permit(:pair, :interval, :startTime, :endTime, :limit)
  end
end
