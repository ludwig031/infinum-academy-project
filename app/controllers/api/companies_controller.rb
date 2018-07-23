module Api
  class CompaniesController < ApplicationController
    def index
      render json: Company.all
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
      company = Company.find params[:id]
      company.destroy
    end

    def update
      company = Company.find params[:id]

      if company.update(company_params)
        render json: company
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
