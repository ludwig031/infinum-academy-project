module Api
  class CompaniesStatisticsController < ApplicationController
    rescue_from ActionController::BadRequest, with: :render_bad_request
    def index
      render json: Company.all, each_serializer: CompanyStatisticsSerializer
    end

    private

    def render_bad_request
      render json: { errors: { company: ['is missing'] } },
             status: :bad_request
    end
  end
end
