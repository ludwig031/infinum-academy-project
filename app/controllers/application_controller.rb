# ApplicationController class inherits a constructor from ActionController::Base
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def authentication
    token = request.headers['Authorization']
    @auth_user = User.find_by(token: token)
    if token && @auth_user

    else
      render json: { errors: { token: ['is invalid'] } },
             status: :unauthorized
    end
  end

  def matches
    output = if params[:date]
               date = Date.parse(params[:date]).strftime('%Y-%m-%d')
               WorldCup.matches_on(date)
             else
               WorldCup.matches
             end
    render json: output
  end
end
