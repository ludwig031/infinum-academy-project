module Api
  class CompaniesController < ApplicationController
    rescue_from ActionController::BadRequest, with: :render_bad_request

    def index
      render json: fetch_companies
    end

    def show
      company = Company.find(params[:id])
      render json: company
    end

    def create
      company = Company.new(company_params)

      if company.save
        render json: company, status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      company = Company.find(params[:id])
      company.destroy
    end

    def update
      company = Company.find(params[:id])

      if company.update(company_params)
        render json: company
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    private

    def render_bad_request
      render json: { errors: { company: ['is missing'] } },
             status: :bad_request
    end

    def fetch_companies
      if params[:filter] == 'active'
        Company.active_flights.order(:name)
      else
        Company.all.order(:name)
      end
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
