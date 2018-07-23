class UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :bad_request
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy
  end

  def update
    user = User.find params[:id]

    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors }, status: :bad_request
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
