module Api
  class UsersController < ApplicationController
    before_action :authentication, only: [:index, :show, :update, :destroy]

    def index
      render json: fetch_users
    end

    def show
      authorize User
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
      authorize User
      user&.destroy
    end

    def update
      authorize User
      if user.update(user_params)
        render json: user
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    private

    def user
      @user ||= User.find(params[:id])
    end

    def fetch_users
      if params[:query]
        User.with_query(params[:query]).order(:email)
      else
        User.order(:email).all
      end
    end

    def authorization
      return if current_user == user
      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end

    def user_params
      params.require(:user).permit(:first_name,
                                   :last_name,
                                   :email,
                                   :password)
    end
  end
end
