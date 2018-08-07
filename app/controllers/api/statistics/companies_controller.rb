module Api
  module Statistics
    class CompaniesController < ApplicationController
      def index
        render json: company_query, each_serializer: CompanyStatisticsSerializer
      end

      def company_query
        Company.joins('LEFT JOIN flights ON flights.company_id = companies.id
                       LEFT JOIN bookings ON bookings.flight_id = flights.id')
               .group('companies.id')
               .select('companies.*, companies.id AS company_id')
               .select('coalesce(sum(bookings.no_of_seats *
                      bookings.seat_price),0) AS total_revenue')
               .select('coalesce(sum(bookings.no_of_seats),0)
                      AS total_no_of_booked_seats')
               .order('company_id')
      end
    end
  end
end
