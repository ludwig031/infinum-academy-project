# ApplicationController class inherits a constructor from ActionController::Base
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authentication

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end

  def authentication
    return if current_user.present?
    render json: { errors: { token: ['is invalid'] } },
           status: :unauthorized
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
