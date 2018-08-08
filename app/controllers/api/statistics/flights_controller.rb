module Api
  module Statistics
    class FlightsController < ApplicationController
      def index
        render json: flight_query, each_serializer: FlightStatisticsSerializer
      end

      private

      def flight_query
        FlightsQuery.new(relation: with_stats)
      end
    end
  end
end
