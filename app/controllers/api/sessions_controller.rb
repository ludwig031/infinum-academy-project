module Api
  class SessionsController < ApplicationController
    rescue_from ActionController::BadRequest, with: :render_bad_request

    before_action :authentication, only: [:destroy]

    def create
      user = User.find_by(email: params[:session][:email])
                 .try(:authenticate, params[:session][:password])

      if user
        render json: Session.new(user: user, token: user.token),
               status: :created
      else
        render json: { errors: { credentials: ['are invalid'] } },
               status: :bad_request
      end
    end

    def destroy
      current_user.regenerate_token
      head :no_content
    end

    private

    def render_bad_request
      render json: { errors: { session: ['is missing'] } },
             status: :bad_request
    end

    def user_params
      params.require(:session).permit(:email, :password)
    end
  end
end
