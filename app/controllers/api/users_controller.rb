module Api
  class UsersController < ApplicationController
    before_action :verify_authenticity_token,
                  only: [:index, :show, :update, :destroy]
    before_action :authorized, only: [:show, :update, :destroy]

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

    def authorized
      if @auth_user.id == params[:id]
      else
        render json: { errors: { resource: ['is forbidden'] } },
               status: :forbidden
      end
    end

    def verify_authenticity_token
      token = request.headers['Authorization']
      user = User.find_by(token: token)

      if token && user
      else
        render json: { errors: { token: ['is invalid'] } },
               status: :unauthorized
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
  end
end
