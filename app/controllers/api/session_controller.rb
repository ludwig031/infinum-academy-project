module Api
  class SessionController < ApplicationController
    before_action :verify_authenticity_token, only: [:destroy]

    def create
      user = User.find_by(email: params[:session][:email])
                 .try(:authenticate, params[:session][:password])

      if user
        # render json: user, status: :created
        render json: Session.new(user: user, token: user.token),
               adapter: :json,
               status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :bad_request
      end
    end

    def destroy
      @auth_user.regenerate_token
      render json: nil, status: 200
    end

    private

    def user_params
      params.require(:session).permit(:email, :password)
    end

    def verify_authenticity_token
      token = request.headers['Authorization']
      @auth_user = User.find_by(token: token)
      if token && @auth_user

      else
        render json: { errors: { token: ['is invalid'] } }, status: 401
      end
    end
  end
end
