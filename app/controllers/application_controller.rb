# frozen_string_literal: true

# ApplicationController class inherits a constructor from ActionController::Base
class ApplicationController < ActionController::Base
  def matches
    output = if request.query_parameters.present?
               WorldCup.matches_on('2018-07-11')
             else
               WorldCup.matches
             end
    render json: output.as_json
  end
end
