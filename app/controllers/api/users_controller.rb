module Api
  class UsersController < ApplicationController
    before_action :verify_authenticity_token
    before_action :set_user, only: [:index, :show, :update, :destroy]

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
      user = User.find(params[:id])
      user.destroy
    end

    def update
      user = User.find(params[:id])

      if user.update(user_params)
        render json: user
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def verify_authenticity_token
      token = request.headers['Authorization']
      @auth_user = User.find_by(token: token)
      if token && @auth_user

      else
        render json: { errors: { token: ['is invalid'] } }, status: 401
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
  end
end
