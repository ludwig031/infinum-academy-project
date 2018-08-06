module Api
  class FlightsStatisticsController < ApplicationController
    rescue_from ActionController::BadRequest, with: :render_bad_request

    def index
      render json: Flight.all, each_serializer: FlightStatisticsSerializer
    end

    private

    def render_bad_request
      render json: { errors: { flight: ['is missing'] } },
             status: :bad_request
    end
  end
end
