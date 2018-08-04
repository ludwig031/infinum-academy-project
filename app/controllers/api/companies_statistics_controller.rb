module Api
  class CompaniesStatisticsController < ApplicationController
    def index
      render json: Company.all, each_serializer: CompanyStatisticsSerializer
    end
  end
end
