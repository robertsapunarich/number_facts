# frozen_string_literal: true

class FunFactsController < ApplicationController
  def show
    query = params[:question]
    service = FunFactsService.new(query)
    service.run
    render json: {
      message: service.fact,
    }
  end
end
