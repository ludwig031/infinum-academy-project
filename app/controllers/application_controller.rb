# ApplicationController class inherits a constructor from ActionController::Base
class ApplicationController < ActionController::Base
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
