module Api
  module Statistics
    class CompaniesController < ApplicationController
      def index
        render json: company_query, each_serializer: CompanyStatisticsSerializer
      end

      private

      def company_query
        FlightsQuery.new(relation: with_stats)
      end
    end
  end
end
