module Api
  class UsersController < ApplicationController
    before_action :authentication, only: [:index, :show, :update, :destroy]
    before_action :authorization, only: [:show, :update, :destroy]

    def index
      render json: if params[:query]
                     User.queried(params[:query])
                   else
                     User.order(:email).all
                   end
      User.all
    end

    def show
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
      user&.destroy
    end

    def update
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
