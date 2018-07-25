module Api
  class SessionController < ApplicationController
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

    private

    def user_params
      params.require(:session).permit(:email, :password)
    end
  end
end
