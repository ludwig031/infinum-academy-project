module Api
  module Statistics
    class CompaniesController < ApplicationController
      def index
        render json: Company.all, each_serializer: CompanyStatisticsSerializer
      end
    end
  end
end
