class CompaniesController < ApplicationController
  def index
    params.permit
    render json: Company.all, each_serializer: CompanySerializer
  end

  def show
    company = Company.find(params[:id])
    params.permit
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
      render json: company.errors, status: :unprocessable_entity
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
    return unless company.update(company_params)
    redirect_to action: 'show', id: company.id
  end

  def company_params
    params.require(:company).permit(:name)
  end
end
