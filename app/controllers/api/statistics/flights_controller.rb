module Api
  module Statistics
    class FlightsController < ApplicationController
      def index
        render json: flight_query, each_serializer: FlightStatisticsSerializer
      end

      def flight_query
        Flight.left_outer_joins(:bookings)
              .group('flights.id')
              .select('flights.*, flights.id AS flight_id')
              .select('coalesce(sum(bookings.no_of_seats *
                      bookings.seat_price),0) AS revenue')
              .select('coalesce(sum(bookings.no_of_seats))
                      AS no_of_booked_seats')
      end
    end
  end
end
