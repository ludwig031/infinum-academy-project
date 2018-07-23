class CompaniesController < ApplicationController
  def index
    render json: Company.all, each_serializer: CompanySerializer
  end

  def show
    company = Company.find(params[:id])
    render json: company, serializer: CompanySerializer
  end

  def new
    Company.new
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

  def edit
    Company.find params[:id]
  end

  def update
    company = Company.find params[:id]

    if company.update(company_params)
      render json: company, status: :ok
    else
      render json: { errors: company.errors }, status: :bad_request
    end
  end

  def company_params
    params.require(:company).permit(:name)
  end
end
