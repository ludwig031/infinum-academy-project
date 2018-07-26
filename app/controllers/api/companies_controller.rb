module Api
  class CompaniesController < ApplicationController
    before_action :verify_authenticity_token
    before_action :set_company, only: [:show, :update, :destroy]

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

    def set_company
      @flight = Company.find(params[:id])
    end

    # def verify_authenticity_token
    #   token = request.headers['Authorization']
    #   @auth_user = User.find_by(token: token)
    #   if token && @auth_user
    #
    #   else
    #     render json: { errors: { token: ['is invalid'] } }, status: 401
    #   end
    # end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
