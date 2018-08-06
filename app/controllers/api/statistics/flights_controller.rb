module Api
  module Statistics
    class FlightsController < ApplicationController
      def index
        render json: Flight.all, each_serializer: FlightStatisticsSerializer
      end
    end
  end
end
