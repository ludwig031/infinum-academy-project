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
    company = Company.new params[:company]
    if company.save
      redirect_to action: 'show', id: company.id
    else
      render action: 'new'
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
    return unless company.update(params[:company])
    redirect_to action: 'show', id: company.id
  end
end
