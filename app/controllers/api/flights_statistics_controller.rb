module Api
  class FlightsStatisticsController < ApplicationController
    def index
      render json: Flight.all, each_serializer: FlightStatisticsSerializer
    end
  end
end
