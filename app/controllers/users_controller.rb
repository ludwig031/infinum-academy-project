class UsersController < ApplicationController
  def index
    params.permit
    render json: User.all, each_serializer: UserSerializer
  end

  def show
    user = User.find(params[:id])
    params.permit
    render json: user, serializer: UserSerializer
  end

  def new
    User.new
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :bad_request
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy
  end

  def edit
    User.find params[:id]
  end

  def update
    user = User.find params[:id]

    if user.update(user_params)
      render json: user, status: :created
    else
      render json: user.errors, status: :bad_request
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
